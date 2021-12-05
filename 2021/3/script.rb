# Pretty ugly solution :( 
# I actually struggled with problem for a while and had to define
#   a class with some modularity to wrap my brain around where I was 
#   messing up.

# The final solution is pretty cool because it prints out each iterative
#   step so you can see the lists shrinking.
class Calculator
  def initialize()
    file = File.open('input.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    @oxygen_list = file_data
    @carbon_list = file_data
    @final_oxygen_list = []
    @final_carbon_list = []
  end

  def do_magic()
    (0..11).each do |bit_position|
      puts "most common oxygen #{calc_most_common(bit_position, @oxygen_list)}"
      puts "most common carbon #{calc_least_common(bit_position, @oxygen_list)}"
      build_oxygen_list(bit_position)
      build_carbon_list(bit_position)

      puts "bit position: #{bit_position}"
      puts "oxygen list: #{@oxygen_list}"
      puts "carbon list: #{@carbon_list}"
    end
  end

  def build_oxygen_list(bit_position)
    new_oxygen_list = []
    mco = calc_most_common(bit_position, @oxygen_list)

    @oxygen_list.each do |row|
      if row[bit_position].to_i == mco
        new_oxygen_list.push(row)
      end
    end

    @oxygen_list = new_oxygen_list
  end

  def build_carbon_list(bit_position)
    new_carbon_list = []
    mcc = calc_least_common(bit_position, @carbon_list)

    @carbon_list.each do |row|
      if row[bit_position].to_i == mcc
        new_carbon_list.push(row)
      end
    end

    @carbon_list = new_carbon_list
  end

  def calc_least_common(bit_position, list)
    one_count = 0
    zero_count = 0

    list.each do |row|
      row[bit_position].to_i == 1 ? one_count += 1 : zero_count += 1
    end

    # NOTE: Important conditional, carbon metric should count ties as 0's
    one_count >= zero_count ? 0 : 1
  end

  def calc_most_common(bit_position, list)
    one_count = 0
    zero_count = 0

    list.each do |row|
      row[bit_position].to_i == 1 ? one_count += 1 : zero_count += 1
    end

    # NOTE: Important conditional, oxygen metric should count ties as 1's
    one_count >= zero_count ? 1 : 0
  end
end

c = Calculator.new
c.do_magic()
