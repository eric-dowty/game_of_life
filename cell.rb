class Cell

  attr_accessor :alive, :neighbors

  def initialize(alive = 0)
    @alive      = alive
    @neighbors  = nil
  end

end


if __FILE__ == $0

  cell = Cell.new(1)
  puts cell.alive
  cell.alive = 0
  puts cell.alive

end
