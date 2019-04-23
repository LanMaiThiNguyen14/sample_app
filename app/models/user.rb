class User < ApplicationRecord
  attr_reader :remember_token
  before_save{email.downcase!}
  validates :name,  presence: true,
             length: {maximum: Settings.user_valid.max_length_name}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
             length: {maximum: Settings.user_valid.max_length_email},
             format: {with: VALID_EMAIL_REGEX},
             uniqueness: {case_sensitive: false}
  validates :password, presence: true,
             length: {minimum: Settings.user_valid.min_length_password}
  has_secure_password
  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               eBCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  private

  def email_downcase
    email.downcase!
  end
end
