file = File.open('input.txt')
file_data = file.readlines.map(&:chomp)
file.close

index = 0
count = 0
prev_sum = nil

file_data.each do |row|
  sum = (file_data[index].to_i || 0) + (file_data[index + 1].to_i || 0) + (file_data[index + 2].to_i || 0)

  if prev_sum && (sum > prev_sum)
    count = count + 1
  end
  prev_sum = sum
  index = index + 1
end

puts count
