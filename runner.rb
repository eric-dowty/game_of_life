require './board'

class Runner

  attr_accessor :board

  def initialize
    @new_board = Board.new
  end

  def iterate_to_next_tick
    @new_board.expand
    @new_board.inspect_rows
    @new_board.evolve_to_next_tick
  end

  def print_board
    @new_board.board.each do |row|
      if row.reduce(:+) > 0
        row.each do |cell|
          if cell == 1
            print "*"
          else
            print " "
          end
        end
        puts "\n"
      end
    end
  end

  def system_dead?
    death = true
    @new_board.board.each do |row|
      row.each do |cell|
        if cell == 1
          death = false
        end
      end
    end
    death
  end

end

if __FILE__ == $0

  run = Runner.new

  iteration = 0
  
  system 'clear'
  print "PRESS CTRL+C TO QUIT\t(iteration ##{iteration})\n\n\n"
  run.print_board
  sleep(1)

  20.times do 
    iteration += 1
    system 'clear'
    print "PRESS CTRL+C TO QUIT\t(iteration ##{iteration})\n\n\n"
    run.iterate_to_next_tick
    run.print_board
    sleep(1)
    if run.system_dead?
      print "THE SYSTEM DIED!!"
      break 
    end
  end

end