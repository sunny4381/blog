class Sys::Group < ApplicationRecord
  belongs_to :tenant, class_name: "Sys::Tenant", required: true
  belongs_to :parent, class_name: "Sys::Group", optional: true
  has_many :children, class_name: "Sys::Group", foreign_key: :parent_id
  has_and_belongs_to_many :users

  validates :gid, presence: true, uniqueness: %i[tenant_id], length: { maximum: 40 }
  validates :name, presence: true, length: { maximum: 40 }

  before_destroy do
    next if children.blank?

    errors.add(:base, :children_are_existed)
    throw :abort
  end

  class << self
    def and_tenant(tenant)
      self.all.where(tenant_id: tenant.id)
    end
  end

  def ancestors(include_self: true)
    ancestors = self.class.find_by_sql(<<-SQL)
    WITH RECURSIVE ancestors as (
      #{self.class.all.where(id: id).to_sql}
      UNION ALL
      #{self.class.all.joins("JOIN ancestors ON ancestors.parent_id = sys_groups.id").to_sql}
    )
    SELECT * FROM ancestors;
    SQL

    unless include_self
      ancestors = ancestors.delete { |group| group.id == id }
    end

    ancestors
  end
end
