# AoC Puzzle 5
# Completed on cousin Sara's wedding day
class BingoCalculator
  def initialize()
    file = File.open('input.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    # The list of numbers, in the order that they're "called"
    @bingo_nums = file_data.shift.split(',').map(&:to_i)

    # 3d array of bingo boards, (in other words, an array of 5x5 bingo boards)
    @boards = parse_boards(file_data)

    # Mirror image of @boards, stores which numbers have been called on that board,
    #   values are either nil if number hasn't been called, or true
    @answers = Array.new(@boards.size){Array.new(5){Array.new(5)}}

    # 1d array to keep track of which boards have already "won"
    @list_of_winners = []

    # Hash object, initialized to nil, stores the most recent winner and the values necessary to calculate winning score
    # - :winning_board
    # - :answers (aka which numbers were filled in)
    # - number that was called for board to win
    @winner = nil
  end

  # Builds a 3-dimensional array, which is an array of 5x5 bingo boards
  def parse_boards(file_data)
    file_data.shift # remove first empty line

    finished = []
    temp = []

    file_data.each do |row|
      if row == ""
        finished.push(temp)
        temp = []
      else
        temp.push(row.strip.split.map(&:to_i))
      end
    end

    finished
  end

  # Main loop! "Call" numbers, mark as filled in, check if there's a new winner from that round
  def do_magic()
    @bingo_nums.each do |num|
      mark_boards(num)
      check_for_winner(num)
      # NOTE: Important conditional, stops iteration when the last winner is found
      break if @list_of_winners.size == @boards.size
    end
  end

  # Searches each bingo board for the number "called" (passed in as a param, num) and marks it
  def mark_boards(num)
    @boards.each_with_index do |board, i|
      board.each_with_index do |row, j|
        row.each_with_index do |bingo_space, k|
          if bingo_space == num
            @answers[i][j][k] = true
          end
        end
      end
    end
  end

  def transpose_matrix(matrix)
    result = [[], [], [], [], []]

    matrix.each do |row|
      row.each_with_index do |val, i|
        result[i].push(val)
      end
    end

    result
  end

  def check_for_winner(num)
    @answers.each_with_index do |answer, i|
      if !@list_of_winners.include?(i) # Skip bingo board if it's already a winner
        columns = transpose_matrix(answer)

        # Check for a completed row
        answer.each_with_index do |row, j|
          if row[0] && row[1] && row[2] && row[3] && row[4] && !@list_of_winners.include?(i)
            @winner = { winning_board: @boards[i], answer_board: answer, winning_call: num }
            @list_of_winners.push(i)
          end
        end

        # Check for a completed column
        columns.each_with_index do |column, j|
          if column[0] && column[1] && column[2] && column[3] && column[4] && !@list_of_winners.include?(i)
            @winner = { winning_board: @boards[i], answer_board: answer, winning_call: num }
            @list_of_winners.push(i)
          end
        end
      end
    end
  end

  def calc_winning_value()
    sum_of_all_unmarked_nums = 0

    @winner[:winning_board].each_with_index do |row, i|
      row.each_with_index do |space, j|
        if @winner[:answer_board][i][j] == nil # if space is unmarked
          sum_of_all_unmarked_nums += space
        end
      end
    end

    sum_of_all_unmarked_nums * @winner[:winning_call]
  end

  def print_answer()
    puts calc_winning_value()
  end
end

bc = BingoCalculator.new
bc.do_magic()
bc.print_answer()
