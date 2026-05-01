class GamesController < ApplicationController
  before_action :authenticate_user!

  def index
    # При первом заходе или после очистки сессии
    if session[:puzzle_board].nil?
      service = PuzzleService.new
      service.shuffle!(1000)
      session[:puzzle_board] = service.to_a
      session[:moves] = 0
      session[:game_active] = false
      session[:start_time] = nil
    end

    # Если флаг game_active не задан — игра не активна
    session[:game_active] = false if session[:game_active].nil?

    # Если игра не активна — стартовое время = nil
    session[:start_time] = nil if session[:game_active] == false

    @board = session[:puzzle_board]
    @moves = session[:moves] || 0
    @game_active = session[:game_active]
    @start_time = session[:start_time]
    @top_scores = Score.where(game_type: '15puzzle').order(time_seconds: :asc).limit(10).includes(:user)
  end

  def new_game
    service = PuzzleService.new
    service.shuffle!(1000)
    session[:puzzle_board] = service.to_a
    session[:moves] = 0
    session[:start_time] = Time.current.to_i   # текущее время в секундах
    session[:game_active] = true
    redirect_to games_path
  end

  def move
    # Если игра не активна — не даём ходить
    unless session[:game_active]
      flash[:alert] = "Игра не начата. Нажмите «Новая игра»."
      redirect_to games_path and return
    end

    tile_index = params[:tile_index].to_i
    board = session[:puzzle_board]
    service = PuzzleService.new(board)

    if service.movable?(tile_index)
      service.swap(tile_index)
      session[:puzzle_board] = service.to_a
      session[:moves] = session[:moves].to_i + 1

      if service.solved?
        elapsed_seconds = Time.current.to_i - session[:start_time].to_i
        # Сохраняем рекорд
        Score.create!(
          user: current_user,
          game_type: '15puzzle',
          time_seconds: elapsed_seconds,
          moves: session[:moves]
        )
        # Останавливаем игру
        session[:game_active] = false
        session[:start_time] = nil

        # Форматируем время для flash (минуты:секунды)
        minutes = elapsed_seconds / 60
        seconds = elapsed_seconds % 60
        formatted_time = "#{minutes}:#{seconds.to_s.rjust(2, '0')}"

        flash[:success] = "🎉 Победа за #{formatted_time}, ходов: #{session[:moves]}! 🎉"
      end
    end
    redirect_to games_path
  end
end