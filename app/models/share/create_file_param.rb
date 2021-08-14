class Share::CreateFileParam
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :tenant, :files, :parent

  validates :tenant, presence: true
  validates :files, presence: true

  def create_files!
    files.each do |file|
      item = Share::File.new(tenant: tenant, name: file.original_filename, size: file.size, file: file)
      item.assign_parent(parent)
      item.save!
    end
  end
end
