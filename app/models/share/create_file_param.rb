class Share::CreateFileParam
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :tenant, :files

  validates :tenant, presence: true
  validates :files, presence: true

  def create_files!
    files.each do |file|
      Share::File.create!(tenant: tenant, name: file.original_filename, size: file.size, file: file)
    end
  end
end
