module Tenanted
  extend ActiveSupport::Concern

  included do
    helper_method :current_tenant
  end

  def current_tenant
    @current_tenant ||= request.env["sophon.tenant"]
  end
end
