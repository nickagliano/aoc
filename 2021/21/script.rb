# frozen_string_literal: true

p1 = 6 - 1 # minus 1 to account for 0 indexed positions
p2 = 8 - 1 # minus 1 to account for 0 indexed positions

@universes = {}

def play(p1, p2, s1, s2)
  return [1, 0] if s1 >= 21

  return [0, 1] if s2 >= 21

  return @universes[[p1, p2, s1, s2]] if @universes[[p1, p2, s1, s2]]

  ans = [0, 0]

  [1, 2, 3].each do |x|
    [1, 2, 3].each do |y|
      [1, 2, 3].each do |z|
        new_position = (p1 + x + y + z) % 10
        new_score = s1 + new_position + 1 # plus 1 to account for 0 indexed positions

        x1, y1 = play(p2, new_position, s2, new_score)
        ans = [ans[0] + y1, ans[1] + x1]
        @universes[[p1, p2, s1, s2]] = ans
      end
    end
  end

  ans
end

puts play(p1, p2, 0, 0).max
