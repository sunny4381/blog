class Share::FilesController < ApplicationController
  cattr_accessor :model_class

  self.model_class = Share::CreateFileParam

  helper_method :model_class, :models, :model

  def new
    @model = model_class.new
    @model.tenant = current_tenant
  end

  def create
    @model = model_class.new(params.require(:model).permit(files: []))
    @model.tenant = current_tenant
    if @model.invalid?
      render file: "new"
      return
    end

    ActiveRecord::Base.transaction do
      @model.create_files!
      true
    end

    redirect_to shares_path, notice: "ファイルを作成しました。"
  end

  def model
    @model ||= models.find(params[:id])
  end
end
