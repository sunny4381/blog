class ApplicationController < ActionController::Base
  include Tenanted
  include Authentication
end
