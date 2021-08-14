class Share::FilesController < ApplicationController
  include Share::CommonController

  self.model_class = Share::Base

  layout "dialog"

  def new
    @model = Share::CreateFileParam.new
    @model.tenant = current_tenant
  end

  def create
    @model = Share::CreateFileParam.new(params.require(:model).permit(files: []))
    @model.tenant = current_tenant
    @model.parent = parent
    if @model.invalid?
      render file: "new"
      return
    end

    ActiveRecord::Base.transaction do
      @model.create_files!
      true
    end

    redirect_to index_path, notice: "ファイルを作成しました。"
  end

  def destroy
    if model.destroy
      redirect_to index_path, notice: "削除しました。"
    else
      render action: :show, status: :bad_request
    end
  end
end
