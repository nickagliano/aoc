# AoC Day 13
# strted at 9:56 am
# part 2 at 10:18 am
# finished at 10:43 am
# I tried to move fast with this one... :/
# I actually think I'm getting better at speedy programming
class Calculator
  def initialize()
    file = File.open('input.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    @grid = []
    @coords = []
    @folds = []

    file_data.each do |row|
      split_row = row.split(',')
      split_row[0] = split_row[0].to_i
      split_row[1] = split_row[1].to_i
      @coords.push(split_row)
    end

    file = File.open('fold_input.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    file_data.each do |row|
      row = row.split(' ')
      row = row.last.split('=')
      row[1] = row[1].to_i
      @folds.push(row)
    end
  end

  def do_magic()
    @folds.each do |fold|
      if fold[0] == 'x' # fold "left"
        fold_val = fold[1]
  
        @coords.each_with_index do |coord, index|
          next if coord[0] < fold_val
  
          og_value = coord[0]
          puts "#{og_value} -> #{(fold_val - (og_value - fold_val))}"
          @coords[index][0] = (fold_val - (og_value - fold_val))
        end
  
        @coords = @coords.uniq
      else # fold y, "up"
        fold_val = fold[1]
  
        @coords.each_with_index do |coord, index|
          next if coord[1] < fold_val
  
          og_value = coord[1]
          @coords[index][1] = (fold_val - (og_value - fold_val))
        end
  
        @coords = @coords.uniq
      end
    end

    puts @coords.size

    50.times do |x|
      @grid.push(Array.new(50, " "))
    end

    @coords.each do |coord|
      @grid[coord.first][coord.last] = "@"
    end

    @grid.each do |row|
      puts row.join(" ")
    end
  end
end

c = Calculator.new
c.do_magic()
