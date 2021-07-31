class DashboardsController < ApplicationController
  helper_method :tenant, :user

  def show
  end

  private

  def tenant
    @tenant ||= request.env["sophon.tenant"]
  end

  def user
    # @user ||= begin
      user_id = session.dig("sophon", tenant.id, "principal", "user_id")
      Sys::User.all.and_tenant(tenant).find(user_id)
    # end
  end
end
