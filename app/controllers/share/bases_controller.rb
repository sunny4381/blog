class Share::BasesController < ApplicationController
  cattr_accessor :model_class

  self.model_class = Share::Base

  helper_method :model_class, :models, :model

  private

  def models
    @models ||= model_class.all.and_tenant(current_tenant).without_deleted.order(name: :asc)
  end

  def model
    @model ||= models.find(params[:id])
  end
end
