# Модель рекорда (связывает Ruby-код с таблицей scores в БД)
class Score < ApplicationRecord
  # Принадлежит одному пользователю
  belongs_to :user

  # Валидации
  validates :time_seconds, presence: true, numericality: { greater_than: 0 }
  validates :moves, presence: true, numericality: { greater_than: 0 }
  validates :game_type, presence: true
end