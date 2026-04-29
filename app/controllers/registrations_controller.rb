# Контроллер для самостоятельной регистрации
class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  # Форма регистрации
  def new
    @user = User.new
  end

  # Создание нового пользователя
  def create
    @user = User.new(user_params)

    if @user.save
      # Автоматический вход после регистрации
      session[:user_id] = @user.id
      redirect_to games_path, notice: "Регистрация успешна! Добро пожаловать!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :nickname)
  end
end