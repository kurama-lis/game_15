# Контроллер для статических страниц (главная, приветственная)
class PagesController < ApplicationController
  # Эта страница доступна даже без авторизации
  skip_before_action :authenticate_user!, only: [:landing]

  # Приветственная страница (форма входа/регистрации)
  def landing
    # Если пользователь уже залогинен — отправляем в игру
    redirect_to games_path if current_user
  end
end
