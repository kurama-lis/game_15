Rails.application.routes.draw do
  # Маршруты для аутентификации
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/signup", to: "registrations#new"
  post "/signup", to: "registrations#create"

  # Главная страница (для неавторизованных)
  root "pages#landing"

  # Игра (только для авторизованных)
  get "games", to: "games#index"
  post "games/move", to: "games#move"
  post "games/new", to: "games#new_game"

  # Выход
  delete "/logout", to: "sessions#destroy"

end

