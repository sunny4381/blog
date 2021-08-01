class LoginController < ApplicationController
  cattr_accessor :model_class

  self.model_class = LoginParam

  helper_method :model_class, :model

  def login
    if request.get?
      model.ref = params[:ref].to_s if params[:ref].present?
      render
      return
    end

    model.attributes = params.require(:model).permit(:uid, :password, :ref)
    model.tenant = current_tenant
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

    destroy_user_session
    create_user_session(user)
    redirect_to model.redirect_to(dashboard_path)
  end

  def logout
    destroy_user_session
    redirect_to login_path, notice: "ログアウトしました。"
  end

  private

  def model
    @model ||= model_class.new
  end
end
