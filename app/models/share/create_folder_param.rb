class Share::CreateFolderParam
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :tenant, :parent

  attribute :name, :string

  validates :tenant, presence: true
  validates :name, presence: true, length: { maximum: 80 }

  def create_folder!
    item = Share::Folder.new(tenant: tenant, name: name)
    item.assign_parent(parent)
    item.save!
  end
end
