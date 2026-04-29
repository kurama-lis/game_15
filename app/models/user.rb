# Модель пользователя (без Devise, чистое Rails + bcrypt)
class User < ApplicationRecord
  # bcrypt предоставляет методы has_secure_password
  has_secure_password

  # Валидации
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:password_digest] }

  # Связь с рекордами (создадим позже)
  has_many :scores, dependent: :destroy
end