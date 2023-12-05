# real input
lines = File.open("input.txt").readlines

# test input
# lines = File.open("test_input.txt").readlines

sum = 0

(0..(lines.length-1)).each do |index|
  first_line = index == 0
  last_line = index == lines.length - 1
  prev_line = lines[index - 1].strip unless first_line
  line = lines[index].strip
  next_line = lines[index + 1].strip unless last_line


  puts line
  line.to_enum(:scan, /\d+/i).map do |number,|
    puts number
    start_index_of_number = $`.size # index of number, accounts for dups per row
    end_index_of_number = start_index_of_number + number.length - 1
    start_of_line = start_index_of_number == 0
    end_of_line = end_index_of_number == line.length - 1
    left_adjacent_index = start_of_line ? 0 : start_index_of_number - 1
    right_adjacent_index = end_of_line ? end_index_of_number : end_index_of_number + 1



    puts prev_line[left_adjacent_index..right_adjacent_index] unless first_line
    puts line[left_adjacent_index] + number + line[right_adjacent_index]
    puts next_line[left_adjacent_index..right_adjacent_index] unless last_line


    symbol_above = first_line ? false : prev_line[left_adjacent_index..right_adjacent_index].match?(/[^.a-zA-Z0-9_]/)
    # puts "symbol_above: #{symbol_above}, prev: #{prev_line[left_adjacent_index..right_adjacent_index]}" unless first_line

    symbol_below = last_line ? false : next_line[left_adjacent_index..right_adjacent_index].match?(/[^.a-zA-Z0-9_]/)
    # puts "symbol_below: #{symbol_below}, next: #{next_line[left_adjacent_index..right_adjacent_index]}" unless last_line

    symbol_before = start_of_line ? false : line[left_adjacent_index].match?(/[^.a-zA-Z0-9_]/)
    # puts "symbol_before: #{line[left_adjacent_index]} #{symbol_before}" unless start_of_line

    symbol_after = end_of_line ? false : line[right_adjacent_index].match?(/[^.a-zA-Z0-9_]/)
    # puts "symbol_after: #{line[right_adjacent_index]} #{symbol_after}" unless end_of_line

    if symbol_above || symbol_below || symbol_before || symbol_after
      puts "YES: #{number}"
      sum = sum + number.to_i
    else
      puts "NO: #{number}"
    end
  end
end

puts "Part 1 ANSWER: #{sum}"

