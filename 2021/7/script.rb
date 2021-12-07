class Calculator
  def initialize()
    file = File.open('input.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    @crab_positions = file_data[0].split(',').map(&:to_i)
  end

  # NOTE: This is not used for in the solution, but I did use it
  #       to get an idea of where the crabs would align themselves
  #       so that I could make the range of possible positions smaller.
  def calc_avg()
    sum = 0
    count = @crab_positions.size

    @crab_positions.each do |c|
      sum += c
    end

    sum / count
  end

  def calc_gas_cost(distance)
    gas_cost = 0

    # Explanation:
    # A little funky, but by iterating over 1..distance and adding the distance at that step
    # to a sum solves the requirement of: "Each change of 1 step in horizontal position
    #  costs 1 more unit of fuel than the last"
    (1..distance).each do |d|
      gas_cost += d
    end

    gas_cost
  end

  def do_magic()
    min_sum_movement = 999999999

    # I played with this range a little using the calc_avg() method
    # to get an idea of where the sweet spot would be
    (400..600).each do |position|
      sum_movement = 0

      @crab_positions.each do |crab_pos|
        distance = (crab_pos - position).abs
        adjusted_distance = calc_gas_cost(distance)

        sum_movement += (adjusted_distance)
      end

      if sum_movement < min_sum_movement
        min_sum_movement = sum_movement
        puts "new min movement: #{min_sum_movement}"
      end
    end

    puts "final answer: #{min_sum_movement}"
  end
end

c = Calculator.new
c.do_magic()
