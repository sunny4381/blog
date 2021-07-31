class LoginParam
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :tenant

  attribute :uid, :string
  attribute :password, :string

  validates :uid, presence: true
  validates :password, presence: true

  def find_user
    Sys::User.all.and_tenant(tenant).find_by(uid: uid)&.authenticate(password)
  end
end
