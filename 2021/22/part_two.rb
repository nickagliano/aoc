# Day 22
file = File.open('input.txt')
file_data = file.readlines.map(&:chomp)
file.close

@e = {} # engine
@c = [] # cuboids
step_num = 0 # step num gives precendence when ranges overlap (higher step num means more recent command)

# Reading and parsing file input
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

  cuboid.push(step_num)
  step_num += 1 # step num gives precendence when ranges overlap (higher step num means more recent command)

  @c.push(cuboid)
end

def reduce()
  # iterate through all engine ranges,
  #   if there's any overlapping, combine or split depending on 'on' or 'off' status

  @e.keys.each do |c|
    t = @e[c].first # type
    s = @e[c].last # step
    xlo = c[0][0]
    xhi = c[0][1]
    ylo = c[1][0]
    yhi = c[1][1]
    zlo = c[2][0]
    zhi = c[2][1]

    @e.keys.each do |cc|
      tt = @e[cc] # type
      ss = @e[cc].last # step
      xxlo = cc[0][0]
      xxhi = cc[0][1]
      yylo = cc[1][0]
      yyhi = cc[1][1]
      zzlo = cc[2][0]
      zzhi = cc[2][1]

      # if there's an overlap, fix
      if t == tt # if both are 'on' or 'off', combine

      else 
        # else, we need to fix the overlap, rely on step number for precendence

      end
    end
  end
end

@c.each do |c|
  type = c.shift.strip
  step_num = c.pop # step num gives precendence when ranges overlap (higher step num means more recent command)

  # mark engine with a range of on / off values
  if type == 'on'
    @e[c] = [true, step_num]
  else
    @e[c] = [nil, step_num]
  end

  reduce()
end
