class User < ApplicationRecord
  scope :show_user, -> {select :id, :name, :email}
  attr_accessor :remember_token
  before_save {email.downcase!}
  validates :name,  presence: true,
    length: {maximum: Settings.constant.username_max_length}
  validates :email, presence: true,
    length: {maximum: Settings.constant.email_max_length},
    format: {with: URI::MailTo::EMAIL_REGEXP},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.constant.password_min_length},
    allow_nil: true

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ?
               BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update remember_digest: nil
  end
end
