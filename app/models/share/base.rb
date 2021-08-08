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

  class << self
    def and_tenant(tenant)
      all.where(tenant_id: tenant.id)
    end

    def without_deleted
      all.where(deleted_at: nil)
    end
  end

  def icon_source
    "<span uk-icon=\"file\"></span>".html_safe
  end
end
