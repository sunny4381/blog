class Sys::Tenant < ApplicationRecord
  self.implicit_order_column = "created_at"

  has_many :virtual_hosts, as: :parent

  validates :name, presence: true, uniqueness: true, length: { maximum: 40 }
  validates :virtual_hosts, presence: true, length: { minimum: 10 }
end
