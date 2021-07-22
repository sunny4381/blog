class Sys::User < ApplicationRecord
  has_secure_password
  belongs_to :tenant, class_name: "Sys::Tenant"
  has_and_belongs_to_many :groups

  validates :uid, presence: true, uniqueness: %i[tenant_id], length: { maximum: 40 }
  validates :name, presence: true, length: { maximum: 40 }
  validates :email, length: { maximum: 40 }
  validates :title, length: { maximum: 40 }
end
