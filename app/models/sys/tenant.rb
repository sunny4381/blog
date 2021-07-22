class Sys::Tenant < ApplicationRecord
  self.implicit_order_column = "created_at"

  has_many :virtual_hosts, as: :parent
  has_one_attached :brand_logo
  attr_accessor :in_rm_brand_logo

  validates :name, presence: true, uniqueness: true, length: { maximum: 40 }
  validates :virtual_hosts, presence: true, length: { maximum: 10 }
  validates :brand_name, length: { maximum: 40 }
  validate :validate_brand_logo

  after_save if: -> { in_rm_brand_logo.present? } do |record|
    record.brand_logo.purge if record.brand_logo.present? && record.brand_logo_blob.id == in_rm_brand_logo.to_s.to_i
  end

  private

  def validate_brand_logo
    return if brand_logo.blank? || !brand_logo.attached?

    content_type = brand_logo.blob.try(:content_type)
    if content_type.blank?
      errors.add :brand_logo, :invalid_type
      return
    end

    unless %w[image/png image/jpeg].include?(content_type)
      errors.add :brand_logo, :invalid_type
      nil
    end
  end
end
