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

    def preload_parents
      sql = <<-SQL
      WITH RECURSIVE ancestors as (
        #{self.all.reorder(nil).to_sql}
        UNION ALL
        #{Sys::Group.unscoped.joins("JOIN ancestors ON ancestors.parent_id = sys_groups.id").to_sql}
      )
      SELECT DISTINCT * FROM ancestors#{self.all.order_values.present? ? " ORDER BY " + self.all.order_values.map(&:to_sql).join(",").gsub("sys_groups", "ancestors") : nil  };
      SQL
      ancestors = self.find_by_sql(sql)

      groups = select_children(ancestors, nil)
      while groups.present? do
        all_children = []
        groups.each do |group|
          children = select_children(ancestors, group.id)
          children.each { |child| child.parent = group }
          all_children += children
        end

        groups = all_children
      end

      ancestors
    end

    private

    def select_children(groups, parent_id)
      groups.select { |group| group.parent_id == parent_id }
    end
  end

  def ancestors(include_self: true)
    ret = include_self ? [ self ] : []

    parent = self.parent
    while parent
      ret << parent
      parent = parent.parent
    end

    ret.reverse!
    ret
  end
end
