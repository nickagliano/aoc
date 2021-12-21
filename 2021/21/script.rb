# frozen_string_literal: true

p1 = 6 - 1 # minus 1 to account for 0 indexed positions
p2 = 8 - 1 # minus 1 to account for 0 indexed positions

@universes = {}

def play(p1, p2, s1, s2)
  return [1, 0] if s1 >= 21 # winner for this universe is player 1

  return [0, 1] if s2 >= 21 # winner for this universe is player 2

  # return the winner of this state--we've seen it in another universe
  return @universes[[p1, p2, s1, s2]] if @universes[[p1, p2, s1, s2]]

  win_count = [0, 0]

  [1, 2, 3].each do |x|
    [1, 2, 3].each do |y|
      [1, 2, 3].each do |z|
        roll_sum = x + y + z
        new_position = (p1 + roll_sum) % 10
        new_score = s1 + new_position + 1 # plus 1 to account for 0 indexed positions

        x1, y1 = play(p2, new_position, s2, new_score)
        win_count = [win_count[0] + y1, win_count[1] + x1]
        @universes[[p1, p2, s1, s2]] = win_count
      end
    end
  end

  win_count
end

puts play(p1, p2, 0, 0).max
