class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      # Приветственное сообщение
      nickname = user.nickname.presence || user.email.split('@').first
      flash[:success] = "Привет, #{nickname}! 👋"
      redirect_to games_path
    else
      flash[:alert] = "Неверный email или пароль"
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Вы вышли из системы"
  end
end