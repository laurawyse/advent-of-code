# real input
lines = File.open("input.txt").readlines

# test input
# lines = File.open("test_input.txt").readlines

# combine lines around empties
elves = lines.slice_when { |i, j| j.strip.empty? }

most_calories = [0, 0, 0]

elves.each do |elf_lines|
  # todo - reduce instead
  current_elf_total = 0
  elf_lines.each do |line|
    current_elf_total = current_elf_total + line.to_i
  end

  if current_elf_total > most_calories.min()
    # this elf is in the top 3!
    most_calories[most_calories.index(most_calories.min())] = current_elf_total
  end
end


puts "ANSWER: top 3 elves have #{most_calories.sum} calories"
