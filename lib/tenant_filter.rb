class TenantFilter
  TENANTS_EXPIRES_IN = 5.minutes

  VIEW_PATHS = [
    File.expand_path("../app/views", __dir__).freeze,
    ActionDispatch::DebugView::RESCUES_TEMPLATE_PATH.dup.freeze
  ].freeze

  ViewClass = ActionView::Base.with_empty_template_cache

  DEFAULT_RESPONSE_APP = lambda do |env|
    request = ActionDispatch::Request.new(env)

    format = request.xhr? ? "text/plain" : "text/html"
    template = ViewClass.with_view_paths(VIEW_PATHS, { host: request.host })
    body = template.render(template: "rescues/blocked_host", layout: "rescues/layout")

    [403, {
      "Content-Type" => "#{format}; charset=#{ActionDispatch::Response.default_charset}",
      "Content-Length" => body.bytesize.to_s
    }, [body]]
  end

  def initialize(app)
    @lock = Mutex.new
    @app = app
    @response_app = DEFAULT_RESPONSE_APP

    return if Rails.application.config.cache_classes

    hold_instance = self
    ActiveSupport::Reloader.to_prepare do
      hold_instance.clear_tenants_cache
    end
  end

  def call(env)
    if detect_tenant(env)
      @app.call(env)
    else
      @response_app.call(env)
    end
  end

  def clear_tenants_cache
    @lock.synchronize do
      @all_tenants = nil
      @all_tenants_loaded_at = nil
    end
  end

  private

  def detect_tenant(env)
    request = Rack::Request.new(env)

    virtual_host = find_virtual_host(request)
    return false if virtual_host.blank?

    tenant = virtual_host.parent

    env["sophon.tenant"] = tenant
    if virtual_host.path != "/"
      env["SCRIPT_NAME"] = join_script_name(env["SCRIPT_NAME"], virtual_host.path)
      env["PATH_INFO"] = env["PATH_INFO"][virtual_host.path.length - 1..]
    end

    true
  end

  def find_virtual_host(request)
    tenants = select_tenants(request)
    return if tenants.blank?

    virtual_hosts = tenants.map(&:virtual_hosts).flatten
    virtual_hosts.sort! { |lhs, rhs| rhs.path.length <=> lhs.path.length }
    virtual_hosts.find { |virtual_host| request.path.starts_with?(virtual_host.path) }
  end

  def select_tenants(request)
    all_tenants.select do |tenant|
      tenant.virtual_hosts.any? do |virtual_host|
        virtual_host.host == request.host
      end
    end
  end

  def tenant_cache_available(now = nil)
    now ||= Time.zone.now
    return false if @all_tenants.nil?
    return false if @all_tenants_loaded_at + TENANTS_EXPIRES_IN < now

    true
  end

  def all_tenants
    @lock.synchronize do
      return @all_tenants if tenant_cache_available

      @all_tenants_loaded_at = Time.zone.now
      @all_tenants = Sys::Tenant.all.includes(:virtual_hosts).to_a
    end
  end

  def join_script_name(base, path)
    ret = File.join(base, path)
    ret = ret[0..-2] if ret.ends_with?("/")
    ret
  end
end
