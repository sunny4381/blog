class Sys::User < ApplicationRecord
  has_secure_password
  belongs_to :tenant, class_name: "Sys::Tenant"
  has_many :group_users, inverse_of: :user, dependent: :destroy
  has_many :groups, through: :group_users, source: :group
  accepts_nested_attributes_for :group_users, allow_destroy: true

  validates :uid, presence: true, uniqueness: %i[tenant_id], length: { maximum: 40 }
  validates :name, presence: true, length: { maximum: 40 }
  validates :email, length: { maximum: 40 }
  validates :title, length: { maximum: 40 }

  class << self
    def and_tenant(tenant)
      all.where(tenant_id: tenant.id)
    end
  end
end
