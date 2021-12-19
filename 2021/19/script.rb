# Don't know how to do this one...

file = File.open('input.txt')
file_data = file.readlines.map(&:chomp)
file.close

scanners = []

file_data.each do |row|
  row.chomp

  if row.include?('---')
    scanners.push([])
  elsif row.size == 0
    # do nothing
  else
    coords = row.split(',').map(&:to_i)
    scanners.last.push(coords)
  end
end

# x, y, z
# Scanner can detect all beacons, but don't know their own positions
# Scanner measurements are relative to the scanner
# Need to find scanners that have at least 12 overlapping beacons
# The scanners also don't know their rotation or facing direction
#   In total, each scanner could be in any of 24 different orientations: 
#     facing positive or negative x, y, or z, and considering any of four directions "up" from that facing.
# 
