class Sys::VirtualHost < ApplicationRecord
  belongs_to :parent, polymorphic: true

  validates :parent, presence: true
  validates :host, presence: true, uniqueness: %i[parent host path], length: { maximum: 40 }, host: true
  validates :path, presence: true, length: { maximum: 40 }, url_path: true
end
