class Sys::TenantsController < ApplicationController
  before_action :authenticate_user!

  cattr_accessor :model_class

  self.model_class = Sys::Tenant

  helper_method :model_class, :models, :model

  def index
  end

  def show
  end

  def new
    @model = model_class.new
  end

  def create
    @model = model_class.new params.require(:model).permit(
      :name, :memo, :enabled_at, :disabled_at, :brand_logo, :brand_name
    )
    @model.virtual_hosts.build params.require(:model).require(:virtual_hosts).permit(:host, :path)
    if @model.save
      redirect_to url_for(action: :show, id: @model), notice: "作成しました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    model.attributes = params.require(:model).permit(
      :name, :memo, :enabled_at, :disabled_at, :brand_logo, :in_rm_brand_logo, :brand_name
    )
    if @model.save
      redirect_to url_for(action: :show), notice: "保存しました。"
    else
      render :edit
    end
  end

  def delete
  end

  def destroy
    if model.destroy
      redirect_to url_for(action: :index), notice: "削除しました。"
    else
      render :delete
    end
  end

  private

  def models
    @models ||= model_class.all.includes(:virtual_hosts).with_attached_brand_logo
  end

  def model
    @model ||= models.find(params[:id])
  end
end
