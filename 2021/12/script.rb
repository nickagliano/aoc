# AoC Day 12
# I have COVID and I think my brain fog is getting to me...
# Took me ~2 hours. How do people do this in 5 minutes????
# The must have a really, really solid background in algorithms
# and mathematics. I just don't know how to approach these problems,
# but some people instantly know to think of it as "nodes" and "edges".
#
# Also, I just don't think I'm a competitive programmer. If I want to write
# code faster I'd need to sacrifice readability, reusablility, etc. I'm
# a web developer / software engineer! I'm a consultant! It's fun to practice,
# but I don't know if I want to do a full dive into learning competitive programming.
class Calculator
  def initialize()
    file = File.open('input.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    @map = {}
    @paths = []

    file_data.each do |row|
      row = row.split('-')
      segment = [ row[0], row[1] ]

      if @map[segment.first]
        @map[segment.first].push(segment.last)
      else
        @map[segment.first] = []
        @map[segment.first].push(segment.last)
      end

      if @map[segment.last]
        @map[segment.last].push(segment.first)
      else
        @map[segment.last] = []
        @map[segment.last].push(segment.first)
      end
    end
  end

  def is_lower_case?(c)
    c == c.downcase
  end

  def get_paths()
    @paths.each do |path|
      next if path.include?('end') # this path is finished

      next_caves = @map[path.last]

      next_caves.each do |cave|
        next if cave == 'start' # don't revisit start

        new_path = path + [cave]
        @paths.push(new_path) if is_valid_path?(new_path)
      end
    end
  end

  # Checks if path is valid, making sure it doesn't violate any "small cave" rules
  def is_valid_path?(path)
    counts = {}
    path.each do |cave|
      count = path.count(cave)
      counts[cave] = count
    end

    num_revisted_small_caves = 0

    counts.each do |c|
      if is_lower_case?(c.first) && c.last == 2
        num_revisted_small_caves += 1
      elsif is_lower_case?(c.first) && c.last > 2
        num_revisted_small_caves = 999 # can't revisit a small cave more than 2 times
      end
    end

    if num_revisted_small_caves <= 1
      return true
    else
      return false # num revisited small caves was > 1 -- not valid
    end
  end

  def get_finished_paths
    candidate_paths = []
    finished_paths = []

    @paths.each do |p|
      if p.include?('end')
        finished_paths.push(p)
      end
    end

    finished_paths
  end

  def do_magic()
    @paths.push(["start"])

    get_paths()

    finished_paths = get_finished_paths() # prune paths that did not lead to an 'end' node

    puts finished_paths.size
  end
end

c = Calculator.new
c.do_magic()