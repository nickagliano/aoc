file = File.open('input.txt')
file_data = file.readlines.map(&:chomp)
file.close

count = 0
prev_row = nil
file_data.each do |row|
  if prev_row && row > prev_row
    count = count + 1
  end
  prev_row = row
end

puts count
