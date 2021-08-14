class Share::Base < ApplicationRecord
  self.table_name = "shares"

  belongs_to :tenant, class_name: "Sys::Tenant"

  has_many :parent_closures,
           class_name: "Share::Closure", foreign_key: 'child_id', inverse_of: :child, dependent: :destroy
  has_many :parents, through: :parent_closures, source: :parent
  has_many :child_closures,
           class_name: "Share::Closure", foreign_key: 'parent_id', inverse_of: :parent, dependent: :destroy
  has_many :children, through: :child_closures, source: :child

  validates :name, presence: true, length: { maximum: 80 }

  before_destroy do
    next if children.blank?

    errors.add(:base, :children_are_existed)
    throw :abort
  end

  class << self
    def and_tenant(tenant)
      all.where(tenant_id: tenant.id)
    end

    def without_deleted
      all.where(deleted_at: nil)
    end
  end

  def assign_parent(parent_folder)
    parent_closures.destroy_all

    if parent_folder.present?
      parent_folder.parents.each do |ancestor|
        parent_closures.build(parent: ancestor, child: self)
      end
    end

    parent_closures.build(parent: self, child: self)
    self.depth = parent_folder.blank? ? 1 : parent_folder.parents.count + 1
  end

  def icon_source
    "<span uk-icon=\"file\"></span>".html_safe
  end
end
