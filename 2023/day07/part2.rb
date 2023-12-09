# input
lines = File.open("input.txt").readlines
# lines = File.open("test_input.txt").readlines

class Hand
  attr_accessor :cards, :strength

  def initialize(cards, strength)
    @cards = cards
    @strength = strength
  end

  CARD_VALUE = {
    'J' => 'a',
    '2' => 'b',
    '3' => 'c',
    '4' => 'd',
    '5' => 'e',
    '6' => 'f',
    '7' => 'g',
    '8' => 'h',
    '9' => 'i',
    'T' => 'j',
    'Q' => 'k',
    'K' => 'l',
    'A' => 'm'
  }

  def type_score
    tally = cards.tally

    # use jokers as wilds
    jokers = cards.tally['J'] || 0
    if jokers > 0
      cards_without_jokers = cards.reject { |c| c == 'J'}
      tally_without_jokers = cards_without_jokers.tally.sort_by { |key, val| val }.reverse.to_h

      highest_val = tally_without_jokers.values.max
      count_highest_val = tally_without_jokers.values.count(highest_val)

      if count_highest_val == 1
        best_card = tally_without_jokers.keys.first
      else
        # find highest card with highest val and add jokers
        best_card = tally_without_jokers.select{|key, value| value == highest_val}.sort_by { |key, val| CARD_VALUE[key] }.reverse.to_h.keys.first
      end
      

      # new cards and tally with wilds replaced
      new_cards = cards.map { |c| c == 'J' ? best_card : c }
      tally = new_cards.tally
    end

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

### PART 2

puts "Part 2 ANSWER: #{total}"

# 251509113 too low