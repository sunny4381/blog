class Share::FoldersController < ApplicationController
  include Share::CommonController

  self.model_class = Share::Base

  layout "dialog"

  def new
    @model = Share::CreateFolderParam.new
    @model.tenant = current_tenant
  end

  def create
    @model = Share::CreateFolderParam.new(params.require(:model).permit(:name))
    @model.tenant = current_tenant
    @model.parent = parent
    if @model.invalid?
      render action: "new", status: :unprocessable_entity
      return
    end

    @model.create_folder!
    redirect_to index_path, notice: "フォルダーを作成しました。"
  end

  def destroy
    if model.destroy
      redirect_to index_path, notice: "削除しました。"
    else
      render action: :show, status: :bad_request
    end
  end
end
