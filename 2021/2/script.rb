file = File.open('input.txt')
file_data = file.readlines.map(&:chomp)
file.close

horizontal = 0
aim = 0
depth = 0

file_data.each do |row|
  tokens = row.split(' ')
  dir = tokens.first
  val = tokens.last.to_i

  case dir
  when 'forward'
    horizontal = horizontal + val
    depth = depth + (aim * val)
  when 'down'
    aim = aim + val
  when 'up'
    aim = aim - val
  else
    'error'
  end
end

puts horizontal * depth
