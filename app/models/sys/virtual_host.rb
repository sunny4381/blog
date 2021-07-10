class Sys::VirtualHost < ApplicationRecord
  belongs_to :parent, polymorphic: true

  validates :parent, presence: true
  validates :host, presence: true, uniqueness: %i[parent host path], length: { maximum: 40 }, host: true
  validates :path, presence: true, length: { maximum: 40 }, url_path: true

  before_validation :normalize_path
  before_save :set_depth

  private

  def normalize_path
    if path.blank?
      self.path = "/"
      return
    end

    self.path = "/#{path}" unless path.starts_with?("/")
    self.path = "#{path}/" unless path.ends_with?("/")
  end

  def set_depth
    self.depth = path.count("/") - 1
  end
end
