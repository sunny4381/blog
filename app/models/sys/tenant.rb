class Sys::Tenant < ApplicationRecord
  self.implicit_order_column = "created_at"
  validates :name, presence: true, uniqueness: true, length: { maximum: 40 }
end
