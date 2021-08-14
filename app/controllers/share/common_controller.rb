module Share::CommonController
  extend ActiveSupport::Concern

  included do
    cattr_accessor :model_class

    before_action :authenticate_user!
    before_action :set_breadcrumbs

    helper_method :model_class, :parent, :models, :model
  end

  private

  def set_breadcrumbs
    breadcrumb "Share", share_path
    return if parent.blank?

    parents = parent.parents.to_a.sort_by(&:depth)
    parents.each do |parent|
      breadcrumb(parent.name, share_parent_path(parent_id: parent))
    end
  end

  def base_criteria
    model_class.all.and_tenant(current_tenant).without_deleted
  end

  def parent
    return @parent if @parent_retrieved

    @parent_retrieved = true
    @parent = base_criteria.where(id: params[:parent_id]).first
  end

  def models
    @models ||=
      if parent.present?
        parent.children.where(depth: parent.depth + 1).order(name: :asc)
      else
        base_criteria.where(depth: 1).order(name: :asc)
      end
  end

  def model
    @model ||= models.find(params[:id])
  end

  def index_path
    if parent.present?
      share_parent_path(parent_id: parent)
    else
      share_path
    end
  end
end
