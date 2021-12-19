# AoC Day 16
# Wow this was hard.
# I kept getting just barely wrong answers with the puzzle input
# and coudln't figure out why -- it turned out the be the init value for
# finding the min was not big enough!
class Calculator
  def initialize()
    file = File.open('input.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    @s = ''

    @packets = {}

    file_data.each do |x|
      row = x.split('')
      row.each do |c|
        int = c.to_i(16) 
        @s += '%0*b' % [4, int]
      end
    end

    @s = @s.split('')
  end

  def read_packet()
    v = @s.shift(3).join().to_i(2) # version id
    type = @s.shift(3).join().to_i(2) # type id
    length = 6 # init length count with header bits

    packet = {}
    packet[:type] = type
    packet[:value] = nil
    packet[:sub_packets] = []
    packet[:length] = nil

    if type == 4 # it's a literal
       res = ''
       done = false

       while !done
        slice = @s.shift(5)
        length += 5
        done = true if slice[0] == '0'

        num = slice.slice(1, 4).join('')
        res += num
       end

       packet[:value] = res.to_i(2)
    else # it's an operator packet
      len_type = @s.shift
      length += 1

      if len_type == '0' # the next 15 bits are a number that represents the total length in bits of the sub-packets contained by this packet.
        size_of_subpackets = @s.shift(15).join('').to_i(2)
        length += 15
        length += size_of_subpackets

        sub_length = 0

        # iterate until size_of_subpackets is met
        while sub_length < size_of_subpackets
          packet[:sub_packets].push(read_packet())

          sub_length = 0

          packet[:sub_packets].each do |sub|
            sub_length += sub[:length]
          end
        end
      else # the next 11 bits are a number that represents the number of sub-packets immediately contained by this packet.
        num_subpackets = @s.shift(11).join('').to_i(2)
        length += 11

        # iterate until num_subpackets is met
        num_subpackets.times do |_|
          packet[:sub_packets].push(read_packet())
        end

        packet[:sub_packets].each do |sub|
          length += sub[:length]
        end
      end
    end # end operator type packet

    packet[:length] = length
    packet[:value] = evaluate_packet(packet)
    packet # return packet
  end

  def evaluate_packet(packet)
    case packet[:type]
    when 0 # sum packet
      sum = 0

      packet[:sub_packets].each do |sub|
        sub[:value] ? sum += sub[:value] : sum += evaluate_packet(sub)
      end

      return sum
    when 1 # product packet
      prod = 1

      packet[:sub_packets].each do |sub|
        sub[:value] ? prod *= sub[:value] : prod *= evaluate_packet(sub)
      end

      return prod
    when 2 # minimum packet
      min = 99999999999999

      packet[:sub_packets].each do |sub|
        val = sub[:value] ? sub[:value] : evaluate_packet(sub)

        if val < min
          min = val
        end
      end

      return min
    when 3 # maximum packet
      max = 0

      packet[:sub_packets].each do |sub|
        val = sub[:value] ? sub[:value] : evaluate_packet(sub)

        if val > max
          max = val
        end
      end

      return max
    when 4 # literal
      return packet[:value]
    when 5 # greater than packet -- their value is 1 if the value of the first sub-packet is greater than the value of the second sub-packet; otherwise, their value is 0. These packets always have exactly two sub-packets.
      first = packet[:sub_packets].first 
      second = packet[:sub_packets].last
      first = first[:value] ? first[:value] : evaluate_packet(first)
      second = second[:value] ? second[:value] : evaluate_packet(second)

      return first > second ? 1 : 0
    when 6 # less than packets - their value is 1 if the value of the first sub-packet is less than the value of the second sub-packet; otherwise, their value is 0. These packets always have exactly two sub-packets.
      first = packet[:sub_packets].first 
      second = packet[:sub_packets].last
      first[:value] ? first = first[:value] : first = evaluate_packet(first)
      second[:value] ? second = second[:value] : second = evaluate_packet(second)

      return first < second ? 1 : 0
    when 7 # equal to packets - their value is 1 if the value of the first sub-packet is equal to the value of the second sub-packet; otherwise, their value is 0.
      first = packet[:sub_packets].first 
      second = packet[:sub_packets].last
      first[:value] ? first = first[:value] : first = evaluate_packet(first)
      second[:value] ? second = second[:value] : second = evaluate_packet(second)

      return first == second ? 1 : 0
    else
    end
  end

  def do_magic()
    packet = read_packet()
    puts "#{packet[:value]}"
  end
end

c = Calculator.new
c.do_magic()
