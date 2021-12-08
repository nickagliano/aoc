# AoC Day 8, I spent ~4 hours on this one... By far the most time I've spent thus far.
#
# The vast majority of the time was spent figuring out how to determine which sets can be
#   subtracted from one another to mathematically prove that a list of segments 
#   represents a certain number. The most ambigious lists, as mentioned in the puzzle instructions,
#   were the segment lists with size 5 [2, 3, 5] and size 6 [0, 6, 9].
class Calculator
  def initialize()
    file = File.open('input.txt')
    # file = File.open('input.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    @input_array = []
    @output_array = []
    @decoded_array = []

    initialize_arrays(file_data)
  end

  def initialize_arrays(file_data)
    input_array = []
    output_array = []

    file_data.each do |r|
      tokens = r.split(' | ')
      inputs = tokens[0].split(' ')
      outputs = tokens[1].split(' ')
      input_array.push(inputs)
      output_array.push(outputs)
    end

    @input_array = input_array
    @output_array = output_array
  end

  def decode_output(output, segment_map)
    # array to store the 4 decoded numbers
    decoded_nums_array = []

    output.each do |coded_num|
      coded_num = coded_num.chars.sort # convert to array, put in alphabetical order (used for matching)

      decoded_num = segment_map.index(coded_num) # find which number this group of segments represents
      decoded_nums_array.push(decoded_num) # add to array
    end

    # convert decoded_nums array into a 4 digit integer
    final_decoded_num = decoded_nums_array.join('').to_i

    # add number to array which will be used for summing
    @decoded_array.push(final_decoded_num)
  end

  def extract_knowledge(segments, segment_map)
    case segments.size
    when 2 # it's a 1
      segment_map[1] = segments.chars
    when 3 # it's a 7
      segment_map[7] = segments.chars
    when 4 # it's a 4
      segment_map[4] = segments.chars
    when 5
      # size of 5 means that it's a 2, 3, or 5
      chars = segments.chars

      # This series of if-else statements strategically calculates
      #   a difference of sets which reveals something about the list of segments
      if (chars - segment_map[1]).size == 3 # it's a 3
        segment_map[3] = chars
      elsif (chars - segment_map[7]).size == 2 # it's a 3
        segment_map[3] = chars
      elsif (chars - segment_map[6]).size == 0 # it's a 5
        segment_map[5] = chars
      elsif (chars - segment_map[5]).size == 2 # it's a 2
        segment_map[2] = chars
      elsif (chars - segment_map[9]).size == 1 # it's a 2
        segment_map[2] = chars
      elsif (chars - segment_map[9]).size == 0 # it's a 3
        segment_map[3] = chars
      end

    when 6
      # size of 6 means that it's a 0, 6, or 9
      chars = segments.chars

      # This series of if-else statements strategically calculates
      #   a difference of sets which reveals something about the list of segments
      if (chars - segment_map[1]).size == 5 # it's a 6
        segment_map[6] = chars
      elsif (chars - segment_map[7]).size == 4 # it's a 6
        segment_map[6] = chars
      elsif (chars - segment_map[4]).size == 2 # it's a 9
        segment_map[9] = chars
      elsif (chars - segment_map[3]).size == 2 # it's a 0
        segment_map[0] = chars
      elsif (chars - segment_map[3]).size == 1 # it's a 9
        segment_map[9] = chars
      end
    when 7
      # it's an 8, do nothing since we already know all segments are in 8 
      # there's no knowledge to be extracted
    end

    return segment_map
  end

  def do_magic()
    @input_array.zip(@output_array).each do |input, output|

      # The segment map holds the group of chars make up the number at that index
      segment_map = [
        [], # 0
        [], # 1
        [], # 2
        [], # 3
        [], # 4
        [], # 5
        [], # 6
        [], # 7
        ['a', 'b', 'c', 'd', 'e', 'f', 'g'], # 8
        [] # 9
      ]

      # Keep "extracting knowledge" until segment map has an answer at each position
      while segment_map.include?([])
        input.each do |segments|
          segments = segments.chars.sort.join # put in alphabetical order (so they can be used to more easily match output)
          segment_map = extract_knowledge(segments, segment_map)
        end
      end

      decode_output(output, segment_map)
    end

    puts @decoded_array.sum
  end
end

c = Calculator.new
c.do_magic()

# NOTES:

# 0 uses six segments: a, b, c, e, f, g (all but d)
# 1 uses two segments: c, f -- unique
# 2 uses five segments: a, c, d, e, g (all but b, f)
# 3 uses five segments: a, c, d, f, g (all but b, e)
# 4 uses four segments: b, c, d, f -- unique
# 5 uses five segments: a, b, d, f, g (all but c, e)
# 6 uses six segments: a, b, d, e, f, g (all but c)
# 7 uses three segments: a, c, f -- unique
# 8 uses all seven segments: a, b, c, d, e, f, g -- unique
# 9 uses six segments: a, b, c, d, f, g (all but e)

# one number uses two segments
# one number uses three segments
# one number uses four segments
# three numbers use five segments
# three numbers use six segments
# one number uses seven segments