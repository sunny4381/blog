class Sys::VirtualHostsController < ApplicationController
  before_action :authenticate_user!

  cattr_accessor :model_class

  self.model_class = Sys::VirtualHost

  helper_method :model_class, :models, :model

  def index
  end

  def show
  end

  def new
    @model = model_class.new
  end

  def create
    @model = model_class.new params.require(:model).permit(:host, :path)
    @model.parent = parent_tenant
    if @model.save
      redirect_to url_for(action: :index), notice: "作成しました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    model.attributes = params.require(:model).permit(:host, :path)
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

  def parent_tenant
    @parent_tenant ||= Sys::Tenant.find(params[:tenant_id])
  end

  def models
    @models ||= model_class.all.where(parent: parent_tenant)
  end

  def model
    @model ||= models.find(params[:id])
  end
end
