# AoC Day 17
class Calculator
  def initialize()
    @valid_traj = []
  end

  def do_magic()
    target_x = [288, 330]
    target_y = [-96, -50]

    (0..500).each do |x|
      (-500..500).each do |y|
        position = [0, 0]
        og = [x, y] # og trajectory
        t = [x, y] # manipulated trajectory
        max_y = 0 # var to keep track of highest y position (part 1)

        500.times do |step|
          position[0] += t[0]
          position[1] += t[1]

          if t[0] == 0
            # do nothing
          elsif t [0] > 0
            t[0] -= 1
          else
            t[0] += 1
          end
    
          t[1] -= 1

          if position[1] > max_y
            max_y = position[1]
          end

          if position[0] >= target_x[0] && position[0] <= target_x[1]
            if position[1] >= target_y[0] && position[1] <= target_y[1]
              @valid_traj.push([og, max_y])
            end
          end
        end
      end
    end

    puts @valid_traj.uniq.size
  end
end

c = Calculator.new
c.do_magic()