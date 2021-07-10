class TenantFilter
  TENANTS_EXPIRES_IN = 5.minutes

  VIEW_PATHS = [
    File.expand_path("../app/views", __dir__).freeze,
    ActionDispatch::DebugView::RESCUES_TEMPLATE_PATH.dup.freeze
  ].freeze

  ViewClass = ActionView::Base.with_empty_template_cache

  DEFAULT_RESPONSE_APP = -> env do
    request = ActionDispatch::Request.new(env)

    format = request.xhr? ? "text/plain" : "text/html"
    template = ViewClass.with_view_paths(VIEW_PATHS, { host: request.host })
    body = template.render(template: "rescues/blocked_host", layout: "rescues/layout")

    [403, {
      "Content-Type" => "#{format}; charset=#{ActionDispatch::Response.default_charset}",
      "Content-Length" => body.bytesize.to_s,
    }, [body]]
  end

  def initialize(app)
    @app = app
    @response_app = DEFAULT_RESPONSE_APP
  end

  def call(env)
    if detect_tenant(env)
      @app.call(env)
    else
      @response_app.call(env)
    end
  end

  private

  def detect_tenant(env)
    request = Rack::Request.new(env)

    tenants = all_tenants.select { |tenant| tenant.virtual_hosts.any? { |virtual_host| virtual_host.host == request.host } }
    return false if tenants.blank?

    virtual_hosts = tenants.map(&:virtual_hosts).flatten
    virtual_hosts.sort! { |lhs, rhs| rhs.path.length <=> lhs.path.length }

    virtual_host = virtual_hosts.find { |virtual_host| request.path.starts_with?(virtual_host.path) }
    return false if virtual_host.blank?

    tenant = virtual_host.parent

    env["sophon.tenant"] = tenant
    if virtual_host.path != "/"
      env["SCRIPT_NAME"] = join_script_name(env["SCRIPT_NAME"], virtual_host.path)
      env["PATH_INFO"] = env["PATH_INFO"][virtual_host.path.length - 1..-1]
    end

    true
  end

  def all_tenants
    now = Time.zone.now
    if @all_tenants.present? && @all_tenants_loaded_at + TENANTS_EXPIRES_IN < now
      return @all_tenants
    end

    @all_tenants_loaded_at = now
    @all_tenants ||= begin
      require "sys/tenant"
      require "sys/virtual_host"
      Sys::Tenant.all.includes(:virtual_hosts).to_a
    end
  end

  def join_script_name(base, path)
    ret = File.join(base, path)
    ret = ret[0..-2] if ret.ends_with?("/")
    ret
  end
end
