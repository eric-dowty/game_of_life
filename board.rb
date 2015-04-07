require 'matrix'
require './cell'

class Board

  attr_accessor :board, :iteration, :cell_rows, :next_seed

  def initialize
    @board      = seed_board
    @iteration  = 0
    @cell_rows  = []
    @next_seed = seed_board
  end

  def seed_board(seed = [], dead_alive = [1,0])
    rand_seed = Proc.new{ dead_alive.sample }
    5.times do 
      seed << [rand_seed[0], rand_seed[0], rand_seed[0], rand_seed[0], rand_seed[0]]
    end
    seed
  end

  def iterate
    @iteration += 1
  end

  def create_row(iteration, row = [])
    (iteration*2 + 5).times do 
      row << 0
    end
    row
  end

  def expand_columns
    board.map! do |row|
      row.unshift(0)
      row.push(0)
    end
  end

  def add_rows
    row_add = @board.unshift(create_row(@iteration))
    row_add = @board.push(create_row(@iteration))
  end

  def expand
    iterate
    expand_columns
    add_rows
  end

  def find_middle_neighbors(row_index, cell_index, neighbors = [])
    left_up    = @board[row_index-1][cell_index-1]
    left_down  = @board[row_index+1][cell_index-1]
    left       = @board[row_index][cell_index-1]
    right_up   = @board[row_index-1][cell_index+1]
    right_down = @board[row_index+1][cell_index+1]
    right      = @board[row_index][cell_index+1]
    up         = @board[row_index-1][cell_index]
    down       = @board[row_index+1][cell_index]
    neighbors << [left_up, up, right_up, right, right_down, down, left_down, left]
  end

  def find_left_neighbors(row_index, cell_index, neighbors = [])
    right_up   = @board[row_index-1][cell_index+1]
    right_down = @board[row_index+1][cell_index+1]
    right      = @board[row_index][cell_index+1]
    up         = @board[row_index-1][cell_index]
    down       = @board[row_index+1][cell_index]
    neighbors << [up, right_up, right, right_down, down]
  end

  def find_right_neighbors(row_index, cell_index, neighbors = [])
    left_up    = @board[row_index-1][cell_index-1]
    left_down  = @board[row_index+1][cell_index-1]
    left       = @board[row_index][cell_index-1]
    up         = @board[row_index-1][cell_index]
    down       = @board[row_index+1][cell_index]
    neighbors << [up, left_up, left, left_down, down]
  end

  def inspect_middle_cells(row, row_index, evolve_row = [])
    row.each_with_index do |cell, cell_index|  
      evolve_cell = Cell.new(cell)
      if cell_index > 0 && cell_index <= row.size-2
        evolve_cell.neighbors = find_middle_neighbors(row_index, cell_index)
        evolve_row << evolve_cell
      elsif cell_index == 0
        evolve_cell.neighbors = find_left_neighbors(row_index, cell_index)
        evolve_row << evolve_cell
      elsif cell_index == row.size-1
        evolve_cell.neighbors = find_right_neighbors(row_index, cell_index)
        evolve_row << evolve_cell
      end
    end
    evolve_row
  end

  def find_top_middle_neighbors(row_index, cell_index, neighbors = [])
    left_down  = @board[row_index+1][cell_index-1]
    left       = @board[row_index][cell_index-1]
    right_down = @board[row_index+1][cell_index+1]
    right      = @board[row_index][cell_index+1]
    down       = @board[row_index+1][cell_index]
    neighbors << [right, right_down, down, left_down, left]
  end

  def find_top_left_neighbors(row_index, cell_index, neighbors = [])
    right_down = @board[row_index+1][cell_index+1]
    right      = @board[row_index][cell_index+1]
    down       = @board[row_index+1][cell_index]
    neighbors << [right, right_down, down]
  end

  def find_top_right_neighbors(row_index, cell_index, neighbors = [])
    left_down  = @board[row_index+1][cell_index-1]
    left       = @board[row_index][cell_index-1]
    down       = @board[row_index+1][cell_index]
    neighbors << [left, left_down, down]
  end

  def inspect_top_cells(row, row_index, evolve_row = [])
    row.each_with_index do |cell, cell_index|  
      evolve_cell = Cell.new(cell)
      if cell_index > 0 && cell_index <= row.size-2
        evolve_cell.neighbors = find_top_middle_neighbors(row_index, cell_index)
        evolve_row << evolve_cell
      elsif cell_index == 0
        evolve_cell.neighbors = find_top_left_neighbors(row_index, cell_index)
        evolve_row << evolve_cell
      elsif cell_index == row.size-1
        evolve_cell.neighbors = find_top_right_neighbors(row_index, cell_index)
        evolve_row << evolve_cell
      end
    end
    evolve_row
  end

  def find_bottom_middle_neighbors(row_index, cell_index, neighbors = [])
    left_up    = @board[row_index-1][cell_index-1]
    left       = @board[row_index][cell_index-1]
    right_up   = @board[row_index-1][cell_index+1]
    right      = @board[row_index][cell_index+1]
    up         = @board[row_index-1][cell_index]
    neighbors << [left_up, up, right_up, right, left]
  end

  def find_bottom_left_neighbors(row_index, cell_index, neighbors = [])
    right_up   = @board[row_index-1][cell_index+1]
    right      = @board[row_index][cell_index+1]
    up         = @board[row_index-1][cell_index]
    neighbors << [up, right_up, right]
  end

  def find_bottom_right_neighbors(row_index, cell_index, neighbors = [])
    left_up    = @board[row_index-1][cell_index-1]
    left       = @board[row_index][cell_index-1]
    up         = @board[row_index-1][cell_index]
    neighbors << [up, left_up, left]
  end

  def inspect_bottom_cells(row, row_index, evolve_row = [])
    row.each_with_index do |cell, cell_index|  
      evolve_cell = Cell.new(cell)
      if cell_index > 0 && cell_index <= row.size-2
        evolve_cell.neighbors = find_bottom_middle_neighbors(row_index, cell_index)
        evolve_row << evolve_cell
      elsif cell_index == 0
        evolve_cell.neighbors = find_bottom_left_neighbors(row_index, cell_index)
        evolve_row << evolve_cell
      elsif cell_index == row.size-1
        evolve_cell.neighbors = find_bottom_right_neighbors(row_index, cell_index)
        evolve_row << evolve_cell
      end
    end
    evolve_row
  end

  def inspect_rows
    @cell_rows.clear
    cells_alive_dead = @board.each_with_index do |row, row_index|
      if row_index > 0 && row_index <= @board.size-2
        @cell_rows << inspect_middle_cells(row, row_index)        
      elsif row_index == 0 
        @cell_rows << inspect_top_cells(row, row_index)
      elsif row_index == @board.size-1
        @cell_rows << inspect_bottom_cells(row, row_index)
      end
    end
    @cell_rows
  end

  def re_seed(cell_row, index, new_row = [])
    cell_row.each do |cell|
      check_sum = cell.neighbors.flatten.reduce(:+)
      if check_sum > 3 && cell.alive == 1
        new_row << 0
      elsif check_sum < 2 && cell.alive == 1
        new_row << 0
      elsif check_sum == 3 && cell.alive == 0
        new_row << 1
      else
        new_row << cell.alive 
      end
    end
    new_row
  end

  def evolve_to_next_tick(next_seed = [])
    @cell_rows.each_with_index do |cell_row, index|
      next_seed << re_seed(cell_row, index)
    end
    @board.clear
    @board = next_seed
  end

end


