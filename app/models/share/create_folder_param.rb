class Share::CreateFolderParam
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :tenant

  attribute :name, :string

  validates :tenant, presence: true
  validates :name, presence: true, length: { maximum: 80 }

  def create_folder!
    Share::Folder.create!(tenant: tenant, name: name)
  end
end
