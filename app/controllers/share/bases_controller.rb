class Share::BasesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_breadcrumbs

  cattr_accessor :model_class

  self.model_class = Share::Base

  helper_method :model_class, :parent, :models, :model

  private

  def set_breadcrumbs
    breadcrumb "Share", share_path

    if parent.present?
      parents = parent.parents.to_a.sort_by { |parent| parent.depth }
      parents.each_with_index do |parent, index|
        breadcrumb(parent.name, share_parent_path(parent_id: parent))
      end
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
    @models ||= begin
      if parent.present?
        parent.children.where(depth: parent.depth + 1).order(name: :asc)
      else
        base_criteria.where(depth: 1).order(name: :asc)
      end
    end
  end

  def model
    @model ||= models.find(params[:id])
  end
end
