class User < ApplicationRecord
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

  private

  def email_downcase
    email.downcase!
  end
end