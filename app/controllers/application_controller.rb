class ApplicationController < ActionController::Base
  # Все страницы требуют авторизации
  before_action :authenticate_user!

  # Метод для доступа к текущему пользователю
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # Проверка авторизации
  def authenticate_user!
    redirect_to login_path, alert: "Пожалуйста, войдите в систему" unless current_user
  end

  # Хелпер для использования в шаблонах
  helper_method :current_user
end