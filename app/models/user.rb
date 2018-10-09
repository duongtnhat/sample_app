class User < ApplicationRecord
  before_save {self.email = email.downcase}
  validates :name,  presence: true,
    length: {maximum: Settings.constant.username_max_length}
  validates :email, presence: true,
    length: {maximum: Settings.constant.email_max_length},
    format: {with: URI::MailTo::EMAIL_REGEXP},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.constant.password_min_length}

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ?
               BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end
end
