# Сервис для управления логикой игры "Пятнашки 15"
class PuzzleService
  attr_reader :board, :size, :blank_pos

  def initialize(board = nil)
    @size = 4
    @board = board || default_board
    @blank_pos = find_blank
  end

  # Начальное (собранное) поле
  def default_board
    (1..15).to_a + [0]
  end

  # Поиск позиции пустой клетки (0)
  def find_blank
    @board.index(0)
  end

  # Перемешивание поля (случайные ходы)
  def shuffle!(steps = 1000)
    steps.times do
      possible_moves = get_possible_moves(@blank_pos)
      random_move = possible_moves.sample
      swap(random_move) if random_move
    end
    self
  end

  # Возвращает индексы клеток, которые можно переместить на пустое место
  def get_possible_moves(blank_idx)
    row = blank_idx / @size
    col = blank_idx % @size
    moves = []
    moves << blank_idx - @size if row > 0      # вверх
    moves << blank_idx + @size if row < 3      # вниз
    moves << blank_idx - 1 if col > 0          # влево
    moves << blank_idx + 1 if col < 3          # вправо
    moves
  end

  # Поменять местами пустую клетку и соседнюю
  def swap(tile_idx)
    @board[@blank_pos], @board[tile_idx] = @board[tile_idx], @board[@blank_pos]
    @blank_pos = tile_idx
  end

  # Можно ли совершить ход? (клик по непустой клетке, соседней с пустотой)
  def movable?(tile_idx)
    get_possible_moves(@blank_pos).include?(tile_idx) && @board[tile_idx] != 0
  end

  # Проверка на победу (поле равно собранному)
  def solved?
    @board == default_board
  end

  # Копия поля для передачи в представление
  def to_a
    @board.dup
  end
end