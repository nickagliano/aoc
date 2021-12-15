# AoC Day 15
# This took me forever. Once I figured out it was dijkstra I still took another
# hour to solve. And I sovled it by luck, because there's still an off-by-one error
# somewhere in here.
class Calculator
  def initialize()
    file = File.open('input.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    @dfs = 0
    @unvisited_nodes = []
    @distances = []
    @map = []

    file_data.each do |x|
      row = x.split('')
      row = row.map(&:to_i)
      @map.push(row)
      5.times do |y|
        @distances.push(Array.new(row.length * 5, 999999999))
      end
    end

    (0..(@map.length*5)-1).each do |x|
      (0..(@map.length*5)-1).each do |y|
        @unvisited_nodes.push([x, y])
      end
    end
  end

  def get_diff(r, c)
    dr = 0
    if r >= (@map.size)
      tile = (r / @map.size)
      if tile >= 1 && tile < 2
        dr = 1
      elsif tile >= 2 && tile < 3
        dr = 2
      elsif tile >= 3 && tile < 4
        dr = 3
      elsif tile >= 4 && tile < 5
        dr = 4
      elsif tile >= 5 && tile < 6
        dr = 5
      end
    end

    dc = 0
    if c >= (@map.size)
      tile = (c / @map.size)
      if tile >= 1 && tile < 2
        dc = 1
      elsif tile >= 2 && tile < 3
        dc = 2
      elsif tile >= 3 && tile < 4
        dc = 3
      elsif tile >= 4 && tile < 5
        dc = 4
      elsif tile >= 5 && tile < 6
        dc = 5
      end
    end

    risk = (@map[r % @map.size][c % @map.size] + (dr + dc))
   
    while risk > 9
      risk -= 9
    end

    risk
  end

  def do_magic()
    @distances[0][0] = 0

    while !@unvisited_nodes.empty?
      current = @unvisited_nodes.shift

      r = current[0]
      c = current[1]
      d = @distances[r][c]

      down = (r+1 <= (@map.size * 5) - 1) ? get_diff(r+1, c) : nil
      up = (r-1 >= 0) ? get_diff(r-1, c) : nil
      right = (c+1 <= (@map.size * 5) - 1) ? get_diff(r, c+1) : nil
      left = (c-1 >= 0) ? get_diff(r, c-1) : nil

      # update down neighbor
      if down && @distances[r+1][c] > (d + down)
        @distances[r+1][c] = d + down
      end

      # update up neighbor
      if up && @distances[r-1][c] > (d + up)
        @distances[r-1][c] = d + up
      end

      # update right neighbor
      if right && @distances[r][c+1] > (d + right)
        @distances[r][c+1] = d + right
      end

      # update left neighbor
      if left && @distances[r][c-1] > (d + left)
        @distances[r][c-1] = d + left
      end
    end

    puts @distances[-1][-1]
  end
end

c = Calculator.new
c.do_magic()
