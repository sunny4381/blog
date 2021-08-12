class Share::FoldersController < ApplicationController
  cattr_accessor :model_class

  self.model_class = Share::CreateFolderParam

  helper_method :model_class, :models, :model

  layout "dialog"

  def new
    @model = model_class.new
    @model.tenant = current_tenant
  end

  def create
    @model = model_class.new(params.require(:model).permit(:name))
    @model.tenant = current_tenant
    if @model.invalid?
      render action: "new", status: :unprocessable_entity
      return
    end

    @model.create_folder!
    redirect_to shares_path, notice: "フォルダーを作成しました。"
  end

  def model
    @model ||= models.find(params[:id])
  end
end
