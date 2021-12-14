# AoC Day 14
# started at 7:41 am
# My algorithm was really slow...
# Fought this one for ~2 hours trying to think of how to speed up the solution
# Had to look up some hints
class Calculator
  def initialize()
    file = File.open('input.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    @char_counts = {}

    @polymer = 'COPBCNPOBKCCFFBSVHKO'

    @polymer.split('').each_with_index do |s, i|
      next unless i <= (@polymer.length - 2)

      char = "#{@polymer[i]}#{@polymer[i+1]}"
      if @char_counts[char]
        @char_counts[char] += 1
      else
        @char_counts[char] = 1
      end
    end

    @rules = []

    file_data.each do |row|
      rule = row.split(' -> ')
      @rules.push(rule)
    end
  end

  def do_magic()
    40.times do |_|
      new_chars = {}

      @rules.each do |rule|
        count = @char_counts[rule[0]]

        if count && count > 0  # if rule input is found in polymer
          @char_counts[rule[0]] = 0 # reset to 0

          # build inserted chars
          first_char = rule[0][0]
          last_char = rule[0][1]
          new_one = "#{first_char}#{rule[1]}"
          new_two = "#{rule[1]}#{last_char}"

          # store count of new chars
          new_chars[new_one] ? new_chars[new_one] += count : new_chars[new_one] = count
          new_chars[new_two] ? new_chars[new_two] += count : new_chars[new_two] = count
        end
      end

      new_chars.each do |new_char|
        count = new_char[1]
        @char_counts[new_char[0]] ? @char_counts[new_char[0]] += count : @char_counts[new_char[0]] = count
      end
    end

    single_char_counts = {}

    @char_counts.each do |char_and_count|
      char = char_and_count[0][0]
      count = char_and_count[1]

      single_char_counts[char] ? single_char_counts[char] += count : single_char_counts[char] = count
    end

    max = single_char_counts.values.max
    min = single_char_counts.values.min

    puts (max - min) - 1 # minus 1 because polymer string ends with min char
  end
end

c = Calculator.new
c.do_magic()
