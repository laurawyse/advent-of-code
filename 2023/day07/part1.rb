# input
lines = File.open("input.txt").readlines
lines = File.open("test_input.txt").readlines

class Hand
  attr_accessor :cards, :strength

  def initialize(cards, strength)
    @cards = cards
    @strength = strength
  end

  CARD_VALUE = {
    '2' => 'a',
    '3' => 'b',
    '4' => 'c',
    '5' => 'd',
    '6' => 'e',
    '7' => 'f',
    '8' => 'g',
    '9' => 'h',
    'T' => 'i',
    'J' => 'j',
    'Q' => 'k',
    'K' => 'l',
    'A' => 'm'
  }

  def type_score
    tally = cards.tally
    kind_counts = tally.keys.count
   
    case kind_counts
    when 1
      return '7' # five_of_a_kind
    when 2
      return tally.values.include?(4) ? '6' : '5' # ? :four_of_a_kind : :full_house
    when 3
      return tally.values.include?(3) ? '4' : '3' # ? :three_of_a_kind : :two_pair
    when 4
      return '2' #one_pair
    when 5
      return '1' #high_card
    end
  end

  def ordered_score
    cards.map do |card|
      CARD_VALUE[card]
    end.join
  end

  def score
    type_score + ordered_score
  end
end

hands = lines.map do |line|
  split_line = line.split(" ")
  Hand.new(split_line[0].strip.chars, split_line[1].strip.to_i)
end

sorted_hands = hands.sort_by(&:score)

total = sorted_hands.each_with_index.reduce(0) do |sum, (hand, index)|
  sum + hand.strength * (index + 1)
end

### PART 1

puts "Part 1 ANSWER: #{total}"
