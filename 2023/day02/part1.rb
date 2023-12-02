# real input
lines = File.open("input.txt").readlines

# test input
# lines = File.open("test_input.txt").readlines


## PART 1

possible_games_id_total = 0

def is_line_possible(line)
  turns = line.partition(/Game \d+:/).last.split(';')
  all_turns_possible = true
  turns.each do |turn|
    blue = turn[/(\d+) blue/, 1]&.to_i || 0
    red = turn[/(\d+) red/, 1]&.to_i || 0
    green = turn[/(\d+) green/, 1]&.to_i || 0
  
    all_turns_possible = false if red > 12 || green > 13 || blue > 14
  end

   all_turns_possible
end


lines.each do |line|
  if is_line_possible(line)
    possible_games_id_total = possible_games_id_total + line[/Game (\d+):/, 1]&.to_i
  end
end

puts "Part 1 ANSWER: #{possible_games_id_total}"


## PART 2

total_power = 0

def calculate_power(line)
  turns = line.partition(/Game \d+:/).last.split(';')
  highest_blue = 0
  highest_red = 0
  highest_green = 0

  turns.each do |turn|
    blue = turn[/(\d+) blue/, 1]&.to_i || 0
    red = turn[/(\d+) red/, 1]&.to_i || 0
    green = turn[/(\d+) green/, 1]&.to_i || 0
  
    highest_blue = blue if blue > highest_blue
    highest_red = red if red > highest_red
    highest_green = green if green > highest_green
  end

   highest_blue * highest_red * highest_green
end

lines.each do |line|
  total_power = total_power + calculate_power(line)
end

puts "Part 2 ANSWER: #{total_power}"