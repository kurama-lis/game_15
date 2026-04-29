# Контроллер для ручной аутентификации (вход/выход)
class SessionsController < ApplicationController
  # Страница входа доступна без авторизации
  skip_before_action :authenticate_user!, only: [:new, :create]

  # Форма входа
  def new
    # Если уже залогинен — перенаправляем в игру
    redirect_to games_path if current_user
  end

  # Обработка попытки входа
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      # Успешный вход
      session[:user_id] = user.id
      redirect_to games_path, notice: "Добро пожаловать, #{user.email}!"
    else
      # Ошибка
      flash.now[:alert] = "Неверный email или пароль"
      render :new, status: :unprocessable_entity
    end
  end

  # Выход
  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Вы вышли из системы"
  end
end