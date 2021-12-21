# Day 20
# This is not right. It's off by a little somehow.

file = File.open('input.txt')
file_data = file.readlines.map(&:chomp)
file.close

enhance = file_data.shift
map = Hash.new(Hash.new('.'))

file_data.each_with_index do |x, i|
  row = x.split('')
  h = Hash.new('.')

  row.each_with_index do |y, j|
    h[j] = y
  end

  map[i] = h
end

def get_neighbors(map, point)
  r = point[0]
  c = point[1]

  a0 = map[r - 1][c - 1]
  a1 = map[r][c - 1]
  a2 = map[r + 1][c - 1]

  m0 = map[r - 1][c]
  m1 = map[r][c]
  m2 = map[r + 1][c]

  b0 = map[r - 1][c + 1]
  b1 = map[r][c]
  b2 = map[r + 1][c + 1]

  [a0, a1, a2, m0, m1, m2, b0, b1, b2].join('')
end

def get_enhanced(enhance, num)
  num = num.gsub(/\./, '0')
  num = num.gsub(/#/, '1')
  num = num.to_i(2)
  enhance[num]
end

def enhance_image(m, enhance, on)
  output_map = m.clone

  rmin = m.keys.min
  rmax = m.keys.max
  cmin = m[1].keys.min
  cmax = m[1].keys.max

  (rmin-5..rmax+4).each do |k0|
    (cmin-5..cmax+4).each do |k1|
      n = get_neighbors(m, [k0, k1])
      o = get_enhanced(enhance, n)

      if m[k0][k1] == '.' && n == '.........'
        # output_map[k0][k1] = '.'
      else
        output_map[k0][k1] = o
      end
    end
  end

  output_map
end

# one_result = enhance_image(map, enhance)
# another_result = enhance_image(one_result, enhance)

2.times do |t|
  map = enhance_image(map, enhance)
end

sum = 0
map.each do |k0, r|
  sum += r.values.count('#')
end

puts sum

48.times do |t|
  map = enhance_image(map, enhance)
end

sum = 0
map.each do |k0, r|
  sum += r.values.count('#')
end

puts sum
