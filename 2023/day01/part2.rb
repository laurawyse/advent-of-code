# real input
lines = File.open("input.txt").readlines

# test input
# lines = File.open("test_input.txt").readlines


# team
lines.each do |line|
  line_without_chars = line.gsub(/\D/, '')
  # puts line_without_chars
end


# mine

WORD_MAP = {
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9,
}

class OrderedNumber 
  attr_accessor :value, :starting_index

  def initialize(value, starting_index)
    @value = value
    @starting_index = starting_index
  end

end


def traverse(str)
  ordered_numbers = []
  # add word versions of number to our list
  WORD_MAP.each do |k, v|
    str.scan(k) { |match| ordered_numbers.push(OrderedNumber.new(v, str.index(k))) }
  end
  
  # add digits
  str.split.('').each_with_index do |char, i|
    if ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'].include?(char)
      ordered_numbers.push(OrderedNumber.new(char, i))
    end
  end

  puts ordered_numbers

  # ordered_numbers.sort_by(:starting_index)
  #   .values_at(0,-1)
  #   .join
  #   .to_i
end

puts 'traverse'
traverse('onetwo1')


def first_last_number(str)
  str.gsub('one', '1')
    .gsub('two', '2')
    .gsub('three', '3')
    .gsub('four', '4')
    .gsub('five', '5')
    .gsub('six', '6')
    .gsub('seven', '7')
    .gsub('eight', '8')
    .gsub('nine', '9')
    .gsub(/\D/, '')
    .split('')
    .values_at(0,-1)
    .join
    .to_i
end

values = []

lines.each do |line|
  values << first_last_number(line)
  # puts values[-1]
  # values << line.split("")
  #   .select { |char| ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'].include?(char)}
  #   .values_at(0,-1)
  #   .join
  #   .to_i
end

puts "ANSWER: #{values.sum}"
