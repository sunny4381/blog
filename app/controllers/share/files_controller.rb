class Share::FilesController < ApplicationController
  before_action :authenticate_user!

  cattr_accessor :model_class

  self.model_class = Share::CreateFileParam

  helper_method :model_class, :models, :model

  layout "dialog"

  def new
    @model = model_class.new
    @model.tenant = current_tenant
  end

  def create
    @model = model_class.new(params.require(:model).permit(files: []))
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

    if parent.present?
      url = share_parent_path(parent_id: parent)
    else
      url = share_path
    end
    redirect_to url, notice: "ファイルを作成しました。"
  end

  def destroy
    if model.destroy
      if parent.present?
        url = share_parent_path(parent_id: parent)
      else
        url = share_path
      end
      redirect_to url, notice: "削除しました。"
    else
      render action: :show, status: :bad_request
    end
  end

  private

  def base_criteria
    Share::Base.all.and_tenant(current_tenant).without_deleted
  end

  def parent
    return @parent if @parent_retrieved

    @parent_retrieved = true
    @parent = base_criteria.where(id: params[:parent_id]).first
  end

  def models
    @models ||= begin
      if parent.present?
        parent.children.order(name: :asc)
      else
        base_criteria.order(name: :asc)
      end
    end
  end

  def model
    @model ||= models.find(params[:id])
  end
end
