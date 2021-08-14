class ApplicationController < ActionController::Base
  include Tenanted
  include Authentication
  include Breadcrumbs
end
