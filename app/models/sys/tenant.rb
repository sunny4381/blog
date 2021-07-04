class Sys::Tenant < ApplicationRecord
  self.implicit_order_column = "created_at"

  has_many :virtual_hosts, as: :parent
  has_one_attached :brand_logo
  attr_accessor :in_rm_brand_logo

  validates :name, presence: true, uniqueness: true, length: { maximum: 40 }
  validates :virtual_hosts, presence: true, length: { maximum: 10 }
  validates :brand_name, length: { maximum: 40 }

  after_save if: ->{ in_rm_brand_logo.present? } do |record|
    record.brand_logo.purge if record.brand_logo.present?
  end
end
