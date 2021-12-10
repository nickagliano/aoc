# AoC Day 10
#   This one was pretty easy. I finished it in about 30 minutes.
#   Not sure how people on the leaderboards did it in 3-5 minutes. Practice?
class Calculator
  def initialize()
    file = File.open('input.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    @rows = file_data.map { |row| 
      row.split('')
    }
  end

  def find_opposite(char)
    case char
    when ')'
      '('
    when ']'
      '['
    when '}'
      '{'
    when '>'
      '<'
    end
  end

  def do_magic()
    incorrect_sum = 0
    incomplete_list = []

    @rows.each do |row|
      list = []
      first_incorrect = nil

      row.each do |char|
        if is_opening(char)
          list.push(char)
        else
          if find_opposite(char) == list.last
            list.pop
          else
            !first_incorrect ? first_incorrect = char : nil
          end
        end
      end

      if first_incorrect
        incorrect_sum += get_incorrect_points(first_incorrect)
      else
        incomplete_list.push(calc_points(list.reverse()))
      end
    end

    incomplete_list = incomplete_list.sort
    puts median(incomplete_list)
  end

  def median(array)
    return nil if array.empty?
    sorted = array.sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2
  end

  def calc_points(list)
    result = 0

    list.each do |char|
      result = (result * 5) + get_incomplete_points(char)
    end

    result
  end

  def is_opening(char)
    ['(', '<', '[', '{'].include?(char)
  end

  def is_closing(char)
    [')', '>', ']', '}'].include?(char)
  end

  def get_incomplete_points(char)
    case char
    when ')'
    when '('
      1
    when ']'
    when '['
      2
    when '}'
    when '{'
      3
    when '>'
    when '<'
      4
    end
  end

  def get_incorrect_points(char)
    case char
    when ')'
      3
    when ']'
      57
    when '}'
      1197
    when '>'
      25137
    end
  end
end

c = Calculator.new
c.do_magic()