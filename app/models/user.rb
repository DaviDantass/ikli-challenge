class User < ApplicationRecord
  has_secure_password

  before_validation :normalize_attributes

  validates :name, presence: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || password.present? }
  validates :password_confirmation, presence: true, on: :create

  private

  def normalize_attributes
    self.name = name.to_s.strip
    self.email = email.to_s.strip.downcase
  end
end
