class FishCalculator
  def initialize()
    file = File.open('input.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    # This is an array of size 9 that holds the # of fish with a certain timer value, 0..8
    # NOTE: This "array of counts" solution is faster than the alternative solution where 
    #       each fish is stores its own timer. The alternative solution is much, much slower computationally.
    @fish_count_array = initialize_fish_timers(file_data)
  end

  def initialize_fish_timers(file_data)
    fish_count_array = [0, 0, 0, 0, 0, 0, 0, 0, 0]

    raw_timers = file_data[0].split(',').map(&:to_i)

    fish_count_array.each_with_index do |timer_slot, i|
      fish_count_array[i] = raw_timers.count(i)
    end

    fish_count_array
  end

  def sum_fish_counts()
    @fish_count_array.inject(0, :+)
  end

  def execute_day()
    # Wow! This is very clean if I do say so myself.

    # Explanation:
    # - Shifting the array of counts does two things:
    #   - It pops off the element at position 0 (which is the # of fish which will reproduce this day)
    #   - It decrements the index of all other elements, leaving the size now at 8, with the highest index of 7,
    #     which also means the "fish with a timer of 8" are no longer stored in the array
    # - Pushing to the array adds the "fish with a timer of 8" back into the array based on the # of fish which
    #   had babies during this step of iteration.
    # - Lastly, incrementing the "fish with a timer of 6" by the number of fish which reproduced fulfills the
    #   requirement: "A lanternfish that creates a new fish resets its timer to 6"
    new_fish_count = @fish_count_array.shift
    @fish_count_array.push(new_fish_count)
    @fish_count_array[6] += new_fish_count
  end

  def do_magic()
    (1..256).each do |day_num|
      execute_day()

      puts "number of fish at end of day: #{day_num}: #{sum_fish_counts()}"
    end
  end
end

fc = FishCalculator.new
fc.do_magic()