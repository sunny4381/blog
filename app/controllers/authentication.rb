module Authentication
  extend ActiveSupport::Concern
  include Tenanted

  included do
    helper_method :user_signed_in?, :current_user
  end

  def authenticate_user!
    if !user_signed_in?
      redirect_to login_path(ref: request.fullpath)
      return
    end

    current_user
  end

  def user_signed_in?
    current_user.present?
  end

  def current_user
    return @current_user if @current_user

    user_id = session.dig("sophon", current_tenant.id, "principal", "user_id")
    return if user_id.blank?

    user = Sys::User.all.and_tenant(current_tenant).find(user_id)
    return if user.blank?

    @current_user = user
  end

  def user_session
    return if !user_signed_in?

    session.dig("sophon", current_tenant.id, current_user.id)
  end

  def create_user_session(user, now: nil)
    # refer to IPA's 「安全なウェブサイトの作り方」
    # we need new session id to protect from session hijacking
    reset_session

    session["sophon"] ||= {}
    session["sophon"][current_tenant.id] = {
      "principal" => { "user_id" => user.id, "created_at" => now },
      user.id.to_s => { "last_request_at" => now }
    }
  end

  def destroy_user_session
    tenant_session = session.dig("sophon", current_tenant.id)
    return if tenant_session.blank?

    tenant_session.delete("principal")
    tenant_session.delete(current_user.id) if user_signed_in?
    nil
  end
end
