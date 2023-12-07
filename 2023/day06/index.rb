# real input
lines = File.open("input.txt").readlines

# test input
# lines = File.open("test_input.txt").readlines

def ways_to_win(max_time, record_distance, starting_speed: 0)
  ways_to_win_count = 0
  (0..max_time).each do |charging_time|
    run_time = max_time - charging_time

    dist = run_time * (starting_speed + charging_time)
    ways_to_win_count += 1 if dist > record_distance
  end

  ways_to_win_count
end

### PART 1

margin = 1

# build input
times = lines[0].split(':')[1].strip.split(" ")
distances = lines[1].split(':')[1].strip.split(" ")

(0..(times.length-1)).each do |game_index|
  ways = ways_to_win(times[game_index].to_i, distances[game_index].to_i)
  puts ways
  margin = margin * ways
end

puts "Part 1 ANSWER: #{margin}"


### PART 2

# build input
time = lines[0].split(':')[1].gsub(/\s+/, "").to_i
distance = lines[1].split(':')[1].gsub(/\s+/, "").to_i
puts "time: #{time}"
puts "distance: #{distance}"

part2 = ways_to_win(time, distance)

puts "Part 2 ANSWER: #{part2}"