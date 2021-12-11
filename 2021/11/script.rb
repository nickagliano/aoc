# AoC Day 11
#   This one took too long. I had a very slow solution that took about 15 minutes to solve part 1,
#   so I refactored it for part 2. The biggest different was that I made the "flash" method recursive.
#   I need to get better at these matrix calculations / conditionals (in the flash method, all of the 
#   if statements could instead be a nested for loop over two arrays = [-1, 0, 1]) 
class Calculator
  def initialize()
    file = File.open('input.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    @flashes = 0

    @grid = []

    file_data.each do |row|
      row = row.split('').map(&:to_i)
      @grid.push(row)
    end
  end

  def flash(i, j)
    @grid[i][j] = nil

    if ((i-1) >= 0) && @grid[i-1][j] # up
      @grid[i-1][j] += 1
      flash(i-1, j) if @grid[i-1][j] > 9
    end

    if ((i+1) <= 9) && @grid[i+1][j] # down
      @grid[i+1][j] += 1 
      flash(i+1, j) if @grid[i+1][j] > 9
    end

    if ((j-1) >= 0) && @grid[i][j-1] # left
      @grid[i][j-1] += 1 
      flash(i, j-1) if @grid[i][j-1] > 9
    end

    if ((j+1) <= 9) && @grid[i][j+1] # right
      @grid[i][j+1] += 1
      flash(i, j+1) if @grid[i][j+1] > 9
    end

    if ((i-1) >= 0) && ((j-1) >= 0) && @grid[i-1][j-1] # up, left
      @grid[i-1][j-1] += 1 
      flash(i-1, j-1) if @grid[i-1][j-1] > 9
    end

    if ((i-1) >= 0) && ((j+1) <= 9) && @grid[i-1][j+1] # up, right
      @grid[i-1][j+1] += 1 
      flash(i-1, j+1) if @grid[i-1][j+1] > 9
    end

    if ((i+1) <= 9) && ((j+1) <= 9) && @grid[i+1][j+1] # down, right
      @grid[i+1][j+1] += 1 
      flash(i+1, j+1) if @grid[i+1][j+1] > 9
    end

    if ((i+1) <= 9) && ((j-1) >= 0) && @grid[i+1][j-1] # down, left
      @grid[i+1][j-1] += 1
      flash(i+1, j-1) if @grid[i+1][j-1] > 9
    end
  end

  def do_magic()
    (1..300).each do |step|
      @grid.each_with_index do |row, i|
        row.each_with_index do |column, j|
          @grid[i][j] += 1
        end
      end

      @grid.each_with_index do |row, i|
        row.each_with_index do |column, j|
          flash(i, j) if @grid[i][j] && @grid[i][j] > 9
        end
      end

      flashes_this_step = 0
      @grid.each_with_index do |row, i|
        row.each_with_index do |column, j|
          if @grid[i][j] == nil
            @grid[i][j] = 0
            flashes_this_step += 1
            @flashes += 1
          end
        end
      end

      puts "..."
      puts "step number: #{step}"
      puts "flashes this step: #{flashes_this_step}"
      puts "total flashes: #{@flashes}"
      break if flashes_this_step == 100
    end
  end
end

c = Calculator.new
c.do_magic()