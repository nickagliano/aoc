# Day 18
# Didn't finish this... spent like... 8 hours. Couldn't get it.
# I'm going to come back to it at some later point.
require 'json'

# path here is the path to the pair that just exploded
def get_left_element_path(array, path)
  p = path.clone

  return nil if path.count(0) == path.count

  if p.last == 0
    while p.last == 0
      p.pop
    end

    while p.last == 0
      p.pop # drill right
    end

    p[-1] = 0

    while get_value_at(array, p).is_a?(Array)
      p.push(1)
    end
  elsif p.last == 1
    p[-1] = 0

    while get_value_at(array, p).is_a?(Array)
      p.push(1) # drill right
    end
  else
    fail 'path should not end in something other than 1 or 0'
  end

  p = nil if p.size == 0

  return p
end

def get_right_element_path(array, path)
  p = path.clone

  return nil if path.count(1) == path.count

  if p.last == 1
    while p.last == 1
      p.pop
    end

    while p.last == 1
      p.pop # drill left
    end

    p[-1] = 1

    while get_value_at(array, p).is_a?(Array)
      p.push(0)
    end
  elsif p.last == 0
    p[-1] = 1

    while get_value_at(array, p).is_a?(Array)
      p.push(0) # drill left
    end
  else
    fail 'path should not end in something other than 1 or 0'
  end

  p = nil if p.size == 0

  return p
end

def get_value_at(array, path)
  case path.size
  when 0
    fail 'path cannot be empty'
  when 1
    array[path[0]]
  when 2
    array[path[0]][path[1]]
  when 3
    array[path[0]][path[1]][path[2]]
  when 4
    array[path[0]][path[1]][path[2]][path[3]]
  when 5
    array[path[0]][path[1]][path[2]][path[3]][path[4]]
  when 6
    array[path[0]][path[1]][path[2]][path[3]][path[4]][path[5]]
  when 7
    array[path[0]][path[1]][path[2]][path[3]][path[4]][path[5]][path[6]]
  when 8
    array[path[0]][path[1]][path[2]][path[3]][path[4]][path[5]][path[6]][path[7]]
  else
    fail 'path cannot be deeper than 5'
  end
end

def update_value_at(array, path, value)
  case path.size
  when 0
    fail 'path cannot be empty'
  when 1
    array[path[0]] = value
  when 2
    array[path[0]][path[1]] = value
  when 3
    array[path[0]][path[1]][path[2]] = value
  when 4
    array[path[0]][path[1]][path[2]][path[3]] = value
  when 5
    array[path[0]][path[1]][path[2]][path[3]][path[4]] = value
  else
    fail 'path cannot be deeper than 5'
  end
end

# Rules:
# 1) Exploding might lead to splitting, but not to more exploding
# 2) Always finish exploding before looking to split
def explode(array, unexplored)

end

# Rules:
# 1) Splitting might lead to exploding
# 2) Don't resume splitting until there are no more more explodable pairs
def split(array, unexplored)

end

def reduce(array, unexplored)
  path = unexplored.shift if unexplored.size > 0

  val = get_value_at(array, path)

  if val.is_a?(Array)
    unexplored.push(path + [0])
    unexplored.push(path + [1])
  end
end

file = File.open('input.txt')
file_data = file.readlines.map(&:chomp)
file.close

array = nil

file_data.each do |row|
  # add new element to array
  array.nil? ? array = [JSON.parse(row)] : array = array + [JSON.parse(row)]

  # initialize unexplored list (starting with 0 and 1 we can reach entire array)
  unexplored = [[0], [1]]

  while !unexplored.empty?
    reduce(array, unexplored)
  end
end

puts "#{array}"
