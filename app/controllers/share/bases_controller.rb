class Share::BasesController < ApplicationController
  include Share::CommonController

  self.model_class = Share::Base
end
