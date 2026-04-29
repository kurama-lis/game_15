class GamesController < ApplicationController
  before_action :authenticate_user!

  def index
    reset_game if session[:puzzle_board].nil?
    @board = session[:puzzle_board]
    @moves = session[:moves] || 0
    @start_time = session[:start_time] || Time.current.to_i
    @top_scores = Score.where(game_type: '15puzzle').order(time_seconds: :asc).limit(10).includes(:user)
  end

  def new_game
    reset_game
    redirect_to games_path
  end

  def move
    tile_index = params[:tile_index].to_i
    board = session[:puzzle_board]
    service = PuzzleService.new(board)

    if service.movable?(tile_index)
      service.swap(tile_index)
      session[:puzzle_board] = service.to_a
      session[:moves] = session[:moves].to_i + 1

      if service.solved?
        elapsed = Time.current.to_i - session[:start_time].to_i
        Score.create!(
          user: current_user,
          game_type: '15puzzle',
          time_seconds: elapsed,
          moves: session[:moves]
        )
        flash[:success] = "Победа за #{elapsed} сек!"
        reset_game
      end
    end
    redirect_to games_path
  end

  private

  def reset_game
    service = PuzzleService.new
    service.shuffle!(1000)
    session[:puzzle_board] = service.to_a
    session[:start_time] = Time.current.to_i
    session[:moves] = 0
  end
end