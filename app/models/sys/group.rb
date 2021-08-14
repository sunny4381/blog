class Sys::Group < ApplicationRecord
  attr_accessor :in_parent_id

  belongs_to :tenant, class_name: "Sys::Tenant"

  has_many :parent_group_closures,
           class_name: "Sys::GroupClosure", foreign_key: 'child_id', inverse_of: :child, dependent: :destroy
  has_many :parents, through: :parent_group_closures, source: :parent
  has_many :child_group_closures,
           class_name: "Sys::GroupClosure", foreign_key: 'parent_id', inverse_of: :parent, dependent: :destroy
  has_many :children, through: :child_group_closures, source: :child
  has_many :group_users, inverse_of: :group, dependent: :destroy
  has_many :users, through: :group_users, source: :user

  before_validation do
    parent_group_closures.build(parent: self, child: self) if parent_group_closures.blank?
    self.depth ||= 1
  end

  validates :gid, presence: true, uniqueness: %i[tenant_id], length: { maximum: 40 }
  validates :name, presence: true, length: { maximum: 40 }
  validates :depth, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :parent_group_closures, presence: true

  before_destroy do
    next if children.blank?

    errors.add(:base, :children_are_existed)
    throw :abort
  end

  class << self
    def and_tenant(tenant)
      all.where(tenant_id: tenant.id)
    end
  end

  def parent
    return if new_record? || parents.count <= 1

    array = parents.to_a
    array.sort_by!(&:depth)
    array[-2]
  end

  # if you want to clear parents, just call `assign_parent(nil)`
  def assign_parent(parent_group)
    parent_group_closures.destroy_all

    if parent_group.present?
      parent_group.parents.each do |ancestor|
        parent_group_closures.build(parent: ancestor, child: self)
      end
    end

    parent_group_closures.build(parent: self, child: self)
    self.depth = parent_group.parents.count + 1
  end

  def move_parent_and_save(parent_group)
    child_group_ids = children.pluck(:id)
    if child_group_ids.include?(parent_group.id)
      errors.add :parent, :cannot_move_to_myself_or_childrent
      return false
    end

    raise NotImplementedError
  end
end
