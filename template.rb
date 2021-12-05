# Ruby template with basic file i/o and class structure
class Calculator
  def initialize()
    file = File.open('input.txt')
    file_data = file.readlines.map(&:chomp)
    file.close

    @data = file_data
  end

  def do_magic()
    # do operations here
  end
end

c = Calculator.new
c.do_magic()