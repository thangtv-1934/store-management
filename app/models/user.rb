class User < ApplicationRecord
  attr_accessor :remember_token

  has_many :stores
  has_many :comments
  has_many :orders

  scope :order_by_column, ->(column){order(column)}

  VALID_EMAIL_REGEX = Settings.validates.email.regex
  USER_PARAMS = %i(name email password password_confirmation).freeze

  validates :name, presence: true, length: {maximum: Settings.validates.name.name_max}
  validates :email, presence: true,
    length: { maximum: Settings.validates.email.lenght },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true,
    length: { minimum: Settings.validates.password.lenght.minimum },
    allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = self.send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update remember_token: nil
  end

  def is_admin?
    role == Settings.role.admin
  end
end
