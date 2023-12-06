# Day 22
file = File.open('input.txt')
file_data = file.readlines.map(&:chomp)
file.close

@e = {} # engine
@c = [] # cuboids

file_data.each do |x|
  type = x[0..2]
  x = x[3..-1].strip
  a = x.split(',')

  cuboid = [type]

  a.each do |c|
    x = c.split('=')[1]
    x = x.split('..')
    x = x.map(&:to_i)
    cuboid.push(x)
  end

  @c.push(cuboid)
end

@c.each do |c|
  type = c.shift.strip
  xlo = c[0][0]
  xhi = c[0][1]
  ylo = c[1][0]
  yhi = c[1][1]
  zlo = c[2][0]
  zhi = c[2][1]

  if xhi < -50 || xlo > 50
    next
  end

  if yhi < -50 || ylo > 50
    next
  end

  if zhi < -50 || zlo > 50
    next
  end

  (xlo..xhi).each do |x|
    (ylo..yhi).each do |y|
      (zlo..zhi).each do |z|
        if type == 'on'
          @e[[x, y, z]] = true
        else
          @e[[x, y, z]] = nil
        end
      end
    end
  end
end

count = 0

@e.keys.each do |c|
  if c[0] >= -50 && c[0] <= 50
    if c[1] >= -50 && c[1] <= 50
      if c[2] >= -50 && c[2] <= 50
        if @e[c]
          count += 1
        end
      end
    end
  end
end

puts count
