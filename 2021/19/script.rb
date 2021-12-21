# Day 19
# Don't know how to do this one...

file = File.open('input.txt')
file_data = file.readlines.map(&:chomp)
file.close

beacons = []
beacons_adjusted = {}

file_data.each do |row|
  row.chomp

  if row.include?('---')
    scanners.push([])
  elsif row.size.zero?
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

# last bit of perm says whether to flip x
# second to last bit of perm says whether to flip y
# third to last bit of perm says whether to flip z
# rest of perm (perm/8) identifies which of the 6 permutations
def rotate(point, perm)
  raise 'perm must be >= 0 and < 48' unless perm >= 0 && perm < 48

  modified = [point[0], point[1], point[2]]

  [0, 1, 2].permutation.to_a.each_with_index do |p, i|
    puts "i: #{i}, p: #{p}"
    modified = [modified[p[0]], modified[p[1]], modified[p[2]]] if (perm / 8).floor == i
  end

  modified[0] *= -1 if perm.odd?
  modified[1] *= -1 if (perm / 2).floor.odd?
  modified[2] *= -1 if (perm / 4).floor.odd?
  modified
end


for i in range(beacons.size)
  for perm in range(48)
    beacons_adjusted[(i,perm)] = [rotate(p, perm) for p in beacons[i]]
  end
end
