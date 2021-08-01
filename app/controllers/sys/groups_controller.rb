class Sys::GroupsController < ApplicationController
  before_action :authenticate_user!

  cattr_accessor :model_class

  self.model_class = Sys::Group

  helper_method :model_class, :models, :model, :options_for_parent

  def index
  end

  def show
  end

  def new
    @model = model_class.new
  end

  def create
    @model = model_class.new params.require(:model).permit(:gid, :name)
    @model.tenant = current_tenant

    parent_id = params.require(:model).permit(:parent_id)[:parent_id]
    @model.assign_parent(models.find(parent_id)) if parent_id.present?

    if @model.save
      redirect_to url_for(action: :show, id: @model), notice: "作成しました。"
    else
      render :new
    end
  end

  def edit
  end

  def update
    model.attributes = params.require(:model).permit(:gid, :name)
    if model.save
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

  def move
    if request.get?
      render
      return
    end

    parent_id = params.require(:model).permit(:parent_id)[:parent_id]
    if parent_id.blank?
      model.errors.add :parent, :blank
      render
      return
    end

    if model.move_parent_and_save(models.find(parent_id))
      redirect_to url_for(action: :show), notice: "移動しました。"
    else
      render
    end
  end

  private

  def models
    @models ||= begin
      models = model_class.all.and_tenant(current_tenant)
      models = models.preload(:parent_group_closures, :parents)
      models = models.order(gid: :asc, name: :asc)
      models
    end
  end

  def model
    @model ||= models.find(params[:id])
  end

  def options_for_parent
    options = models.map { |group| [ "#{group.name} (#{group.gid})", group.id ] }
    selected = nil
    if model.persisted? && model.parents.count > 1
      parents = model.parents.to_a
      parents.sort_by!(&:depth)
      selected = parents[-2].id
    end
    view_context.options_for_select(options, selected)
  end
end
