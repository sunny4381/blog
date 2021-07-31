class LoginController < ApplicationController
  cattr_accessor :model_class

  self.model_class = LoginParam

  helper_method :model_class, :model, :tenant

  def login
    if request.get?
      render
      return
    end

    model.attributes = params.require(:model).permit(:uid, :password)
    model.tenant = tenant
    if model.invalid?
      render
      return
    end

    user = model.find_user
    if !user
      model.errors.add :base, "パスワードが違います。"
      render
      return
    end

    # refer to IPA's 「安全なウェブサイトの作り方」
    # we need new session id to protect from session hijacking
    reset_session

    session["sophon"] ||= {}
    session["sophon"][tenant.id] ||= {}
    session["sophon"][tenant.id]["principal"] = { "user_id" => user.id, "accessed_at" => Time.zone.now.to_i }

    redirect_to dashboard_path
  end

  private

  def model
    @model ||= model_class.new
  end

  def tenant
    @tenant ||= request.env["sophon.tenant"]
  end
end
