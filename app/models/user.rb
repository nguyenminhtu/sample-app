class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_reader :remember_token

  validates :name, presence: true,
    length: {
      minimum: Settings.name.minimum,
      maximum: Settings.name.maximum
    }
  validates :email, presence: true,
    length: {maximum: Settings.email.maximum},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.password.minimum},
    allow_nil: true

  before_create :create_activation_token
  before_save :email_downcase

  scope :most_recent, ->{order created_at: :desc}
  scope :active, ->{where activated: true}

  has_secure_password

  def gravatar_url options = {size: 80}
    gravatar_id = Digest::MD5.hexdigest email.downcase
    size = options[:size]
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  end

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember_token= val
    self.remember_token = val
  end

  def remember
    remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def active_user
    update_attributes activated: true, activated_at: Time.zone.now
  end

  def forget
    update_attributes remember_digest: nil
  end

  def send_mail
    UserMailer.account_activation(self).deliver_now
  end

  def auth_user? token
    !activated? && activation_digest == token
  end

  private

  def email_downcase
    self.email = email.downcase
  end

  def create_activation_token
    self.activation_digest = User.new_token
  end
end
