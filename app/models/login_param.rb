class LoginParam
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :tenant

  attribute :uid, :string
  attribute :password, :string
  attribute :ref, :string

  validates :uid, presence: true
  validates :password, presence: true

  def validate_and_find_user
    return if invalid?

    user = find_user
    if user.blank?
      errors.add :base, "パスワードが違います。"
      return
    end

    user
  end

  def find_user
    Sys::User.all.and_tenant(tenant).find_by(uid: uid)&.authenticate(password)
  end

  def redirect_to(default_path)
    return ref if TrustedUrlValidator.valid?(ref)

    default_path
  end
end
