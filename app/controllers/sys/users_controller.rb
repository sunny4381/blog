class Sys::UsersController < ApplicationController
  before_action :authenticate_user!

  cattr_accessor :model_class

  self.model_class = Sys::User

  helper_method :model_class, :models, :model, :groups

  def index
  end

  def show
  end

  def new
    @model = model_class.new
  end

  def create
    @model = model_class.new params.require(:model).permit(
      :uid, :name, :password, :password_confirmation, :email, :title, :enabled_at, :disabled_at,
      group_users_attributes: %i[group_id]
    )
    @model.tenant = current_tenant

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
      :uid, :name, :password, :password_confirmation, :email, :title, :enabled_at, :disabled_at,
      group_users_attributes: %i[group_id]
    )

    # group_ids = params.require(:model).permit(group_ids: [])[:group_ids]
    # group_ids.select!(&:present?)
    # model.group_users.destroy_all
    # if group_ids.present?
    #   group_ids.each do |group_id|
    #     model.group_users.build(group_id: group_id)
    #   end
    # end

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
    @models ||= model_class.all.and_tenant(current_tenant).preload(:group_users, :groups)
  end

  def model
    @model ||= models.find(params[:id])
  end

  def groups
    @groups ||= begin
      groups = Sys::Group.all.and_tenant(current_tenant)
      groups = groups.preload(:parent_group_closures, :parents).order(gid: :asc, name: :asc)
      groups
    end
  end
end
