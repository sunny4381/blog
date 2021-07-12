class Sys::GroupsController < ApplicationController
  cattr_accessor :model_class

  self.model_class = Sys::Group

  helper_method :model_class, :models, :model, :tenant

  def index
  end

  def show
  end

  def new
    @model = model_class.new
  end

  def create
    @model = model_class.new params.require(:model).permit(:gid, :name, :parent_id)
    @model.tenant = tenant
    if @model.save
      redirect_to url_for(action: :show, id: @model), notice: "作成しました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    model.attributes = params.require(:model).permit(:gid, :name, :parent_id)
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
    @models ||= model_class.all.order(gid: :asc)
  end

  def model
    @model ||= models.find(params[:id])
  end

  def tenant
    @tenant ||= request.env["sophon.tenant"]
  end
end
