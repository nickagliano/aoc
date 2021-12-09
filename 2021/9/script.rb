# AoC Day 9
#   This one took about an hour and a half.
#   I finished part one in about 15 minutesm but a lot of time time was wasted
#   in part 2. I didn't see the instruction that basins can't include a 9, so my basins 
#   much, much too big.
class Calculator
  def initialize()
    file = File.open('input.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    @height_map = []

    file_data.each do |row|
      @height_map.push(row.split(''))
    end

    @low_points = []
  end

  def right(i, j)
    return false if j == (@height_map[0].size - 1)
    @height_map[i][j+1].to_i
  end

  def left(i, j)
    return false if j == 0
    @height_map[i][j-1].to_i
  end

  def up(i, j)
    return false if i == 0
    @height_map[i-1][j].to_i
  end

  def down(i, j)
    return false if i == (@height_map.size - 1)
    @height_map[i+1][j].to_i
  end

  def do_magic()
    @height_map.each_with_index do |row, i|
      row.each_with_index do |val, j|
        val = val.to_i

        if i == 0 && j == 0 # top left corner
          # 2 comparisons
          @low_points.push([i, j]) if ((right(i, j) > val) && (down(i, j) > val))

        elsif i == 0 && (j != (row.size - 1)) # first row, not in a corner
          # 3 comparisons
          @low_points.push([i, j]) if ((right(i, j) > val) && (down(i, j) > val) && (left(i, j) > val))

        elsif i == 0 && (j == (row.size - 1)) # top right corner
          # 2 comparisons
          @low_points.push([i, j]) if ((left(i, j) > val) && (down(i, j) > val))

        elsif i == (@height_map.length - 1) && j == 0 # bottom left corner
          # 2 comparisons
          @low_points.push([i, j]) if ((up(i, j) > val) && (right(i, j) > val))

        elsif i == (@height_map.length - 1) && (j != (row.size - 1)) # bottom row, not in a corner
          # 3 comparisons
          @low_points.push([i, j]) if ((right(i, j) > val) && (up(i, j) > val) && (left(i, j) > val))

        elsif i == (@height_map.length - 1) && (j == (row.size - 1)) # bottom right corner
          # 2 comparisons
          @low_points.push([i, j]) if ((up(i, j) > val) && (left(i, j) > val))

        elsif j == 0 # left side but not in corner
          # 3 comparisons
          @low_points.push([i, j]) if ((up(i, j) > val) && (right(i, j) > val) && (down(i, j) > val))

        elsif j == (row.size - 1) # right side but not in corner
          # 3 comparisons
          @low_points.push([i, j]) if ((up(i, j) > val) && (left(i, j) > val) && (down(i, j) > val))

        else # normal
          # 4 comparisons
          @low_points.push([i, j]) if ((up(i, j) > val) && (left(i, j) > val) && (down(i, j) > val) && (right(i, j) > val))
        end
      end
    end

    find_basins()
  end

  # The find_basins() method uses the @low_points from part 1 as the starting points of the basins, 
  #   then sort of expands out from there
  def find_basins()
    finished_basins = []

    @low_points.each_with_index do |coords, index|
      finished_basins.push([coords])
      coords_to_check = []
      coords_to_check.push([coords.first, coords.last])

      # This is the "expand out" part of the algorithm. It adds any coordinate that meets the criteria
      #   to a list, and keeps adding until it hits the boundaries of the basin.
      while !coords_to_check.empty?
        i = coords_to_check.first[0]
        j = coords_to_check.first[1]
        current_val = @height_map[i][j].to_i
        up_val = up(i, j) # gets value from moving up one coordinate (or false if it can't move up)
        down_val = down(i, j) # ''              '' down             ''                 ''       down)
        left_val = left(i, j) # ''              '' left             ''                 ''       left)
        right_val = right(i, j) # ''           ''  right             ''                ''       right)

        if up_val && (up_val > current_val) && up_val != 9
          up_coords = [i-1, j]
          coords_to_check.push(up_coords) if !finished_basins[index].include?(up_coords)
          finished_basins[index].push(up_coords) if !finished_basins[index].include?(up_coords)
        end

        if down_val && (down_val > current_val) && down_val != 9
          down_coords = [i+1, j]
          coords_to_check.push(down_coords) if !finished_basins[index].include?(down_coords)
          finished_basins[index].push(down_coords) if !finished_basins[index].include?(down_coords)
        end

        if left_val && (left_val > current_val) && left_val != 9
          left_coords = [i, j-1]
          coords_to_check.push(left_coords) if !finished_basins[index].include?(left_coords)
          finished_basins[index].push(left_coords) if !finished_basins[index].include?(left_coords)
        end

        if right_val && (right_val > current_val) && right_val != 9
          right_coords = [i, j+1]
          coords_to_check.push(right_coords) if !finished_basins[index].include?(right_coords)
          finished_basins[index].push(right_coords) if !finished_basins[index].include?(right_coords)
        end

        coords_to_check.shift
      end
    end

    print_result(finished_basins)
  end

  # Not at all optimal for finding the size 3 largest sizes, but simple enough
  def print_result(finished_basins)
    sizes = []

    finished_basins.each do |fb|
      sizes.push(fb.size)
    end

    biggest_basins = sizes.max(3)

    puts (biggest_basins[0] * biggest_basins[1] * biggest_basins[2])
  end
end

c = Calculator.new
c.do_magic()