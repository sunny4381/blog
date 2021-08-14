module Breadcrumbs
  extend ActiveSupport::Concern

  included do
    helper_method :breadcrumbs, :breadcrumb
  end

  def breadcrumbs
    @breadcrumbs ||= []
  end

  def breadcrumb(*args)
    breadcrumbs << args
  end
end
