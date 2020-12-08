# real input
lines = File.open("input.txt").readlines

# test input
# lines = File.open("test_input.txt").readlines

# combine lines around empties
elves = lines.slice_when { |i, j| j.strip.empty? }

most_calories = 0
elf_with_most = 0
elf_count = 1

elves.each do |elf_lines|
  # todo - reduce instead
  current_elf_total = 0
  elf_lines.each do |line|
    current_elf_total = current_elf_total + line.to_i
  end

  if current_elf_total > most_calories
    # this elf has more than any before
    most_calories = current_elf_total
    elf_with_most = elf_count
  end

  elf_count = elf_count + 1 # elf count is wrong hmmm
end


puts "ANSWER: #{most_calories} calories carried by elf #{elf_with_most}"
