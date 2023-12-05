# real input
lines = File.open("input.txt").readlines

# test input
# lines = File.open("test_input.txt").readlines

class ScratchCard
  attr_accessor :id, :winning_numbers, :card_numbers

  def initialize(id, winning_numbers, card_numbers)
    @id = id
    @winning_numbers = winning_numbers
    @card_numbers = card_numbers
  end

  def points
    matches = @winning_numbers.intersection(@card_numbers).count
    if matches == 0
      0
    elsif matches == 1
      1
    else
      2 ** (matches - 1)
    end
  end

  def matches
    @winning_numbers.intersection(@card_numbers).count
  end
end

def build_scratch_card(line)
  id = line[(line.index('Card ')+4)..(line.index(':')-1)].strip
  winning_numbers = line[(line.index(':')+1)..(line.index('|')-1)].strip.split(' ').map { |n| n.to_i }
  card_numbers = line[(line.index('|')+1)..line.length].strip.split(' ').map { |n| n.to_i }

  ScratchCard.new(id, winning_numbers, card_numbers)
end


### PART 1

sum = 0

(0..(lines.length-1)).each do |index|
  sum = sum + build_scratch_card(lines[index]).points
end

puts "Part 1 ANSWER: #{sum}"


### PART 2

card_counts = {}

# add initial counts
(0..(lines.length-1)).each do |index|
  card = build_scratch_card(lines[index])
  card_counts[card.id] = 1
end

# add copy counts
(0..(lines.length-1)).each do |index|
  card = build_scratch_card(lines[index])
  card_matches = card.matches

  ((index+1)..(index+card_matches)).each do |additional_card_index|
    break if additional_card_index >= lines.length
    additional_line = lines[additional_card_index]
    additional_card = build_scratch_card(additional_line)

    card_counts[additional_card.id] += card_counts[card.id]
  end
end

puts "Part 2 ANSWER: #{card_counts.values.sum}"