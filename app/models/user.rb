class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true,
    length: {
      minimum: Settings.name.minimum,
      maximum: Settings.name.maximum
    }
  validates :email, presence: true,
    length: {maximum: Settings.email.maximum},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: Settings.password.minimum},
    presence: true

  before_save :email_downcase

  has_secure_password

  private
  def email_downcase
    self.email = email.downcase
  end
end
