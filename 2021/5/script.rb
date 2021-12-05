# AoC Day 5
class Calculator
  def initialize()
    file = File.open('input.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    @raw_data = file_data
    @grid = create_empty_grid(990, 990)
  end

  def create_empty_grid(h, w)
    Array.new(h){Array.new(w)}
  end

  # x1y1 and x2y2 are arrays of size 2 
  def draw_line(x1, y1, x2, y2)
    delta_x = x2 - x1
    delta_y = y2 - y1

    if delta_x == 0 # it's a vertical line
      if y2 > y1
        (y1..y2).each do |num|
          @grid[x1][num] ? @grid[x1][num] += 1 : @grid[x1][num] = 1
        end
      else
        (y2..y1).each do |num|
          @grid[x1][num] ? @grid[x1][num] += 1 : @grid[x1][num] = 1
        end
      end
    elsif delta_y == 0 # it's a horizontal line
      if x2 > x1
        (x1..x2).each do |num|
          @grid[num][y1] ? @grid[num][y1] += 1 : @grid[num][y1] = 1
        end
      else
        (x2..x1).each do |num|
          @grid[num][y1] ? @grid[num][y1] += 1 : @grid[num][y1] = 1
        end
      end
    else # it's a diagonol line
      if x2 > x1 && y2 > y1
        (x1..x2).each_with_index do |x, i|
          @grid[x][y1+i] ? @grid[x][y1+i] += 1 : @grid[x][y1+i] = 1
        end
      elsif x2 > x1 && y2 < y1
        (x1..x2).each_with_index do |x, i|
          @grid[x][y1-i] ? @grid[x][y1-i] += 1 : @grid[x][y1-i] = 1
        end
      elsif x2 < x1 && y2 > y1
        (x2..x1).each_with_index do |x, i|
          @grid[x][y2-i] ? @grid[x][y2-i] += 1 : @grid[x][y2-i] = 1
        end
      elsif x2 < x1 && y2 < y1
        (x2..x1).each_with_index do |x, i|
          @grid[x][y2+i] ? @grid[x][y2+i] += 1 : @grid[x][y2+i] = 1
        end
      else
        puts "error, uh oh, this should happen"
      end
    end
  end

  def print_answer()
    count = 0

    @grid.each do |row|
      row.each do |space|
        if space && space > 1
          count += 1
        end
      end
    end

    puts count
  end

  def do_magic()
    # Iterate through coordinates
    @raw_data.each do |row|
      coords = row.split(' -> ')
      x1y1 = coords.first.split(',')
      x2y2 = coords.last.split(',')
      x1 = x1y1.first.to_i
      y1 = x1y1.last.to_i
      x2 = x2y2.first.to_i
      y2 = x2y2.last.to_i
      draw_line(x1, y1, x2, y2)
    end
  end
end

c = Calculator.new
c.do_magic()
c.print_answer()