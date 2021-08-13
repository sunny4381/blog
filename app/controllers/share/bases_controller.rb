class Share::BasesController < ApplicationController
  cattr_accessor :model_class

  self.model_class = Share::Base

  helper_method :model_class, :models, :model

  def destroy
    if model.destroy
      redirect_to url_for(action: :index), notice: "削除しました。", status: :see_other
    else
      render action: :show, status: :bad_request
    end
  end

  private

  def models
    @models ||= model_class.all.and_tenant(current_tenant).without_deleted.order(name: :asc)
  end

  def model
    @model ||= models.find(params[:id])
  end
end
