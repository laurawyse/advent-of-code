def sum_for_all_groups(file_name, everyone: false)
  get_letters_for_groups(file_name, everyone: everyone).reduce(0) { |sum, letters| sum + letters.length }
end

def get_letters_for_groups(file_name, everyone: false)
  lines = File.open(file_name).readlines

  # combine lines around empties
  groups = lines.slice_when { |i, j| j.strip.empty? }

  # combine separate group lines into 1 array of chars
  group_letters = groups.map do |group|
    everyone ? get_everyone_letters_for_group(group) : get_anyone_letters_for_group(group)
  end
  # puts group_letters.to_s
  group_letters
end

def get_anyone_letters_for_group(group_lines)
  group_letters = []

  # combine separate group lines into 1 array of chars
  group_lines.each { |line| group_letters.concat(line.strip.chars) }

  group_letters.uniq
end

def get_everyone_letters_for_group(group_lines) # todo
  group_letters = []

  # combine separate group lines into 1 array of chars
  ('a'..'z').to_a.each do |letter|
    lines_including_letter = group_lines.select{ |line| line.strip.include? letter }
    lines_excluding_blanks = group_lines.select{ |line| line.strip != '' }
    if lines_including_letter.length == lines_excluding_blanks.length
      group_letters.push(letter)
    end
  end

  group_letters
end

# part 1 tests
part_1_test_1 = get_letters_for_groups('test_input_1.txt')[0].length
raise "failed: #{part_1_test_1} does not equal 6" if part_1_test_1 != 6

part_1_test_2 = get_letters_for_groups('test_input_2.txt')
raise "failed: #{part_1_test_2[0].length} does not equal 3" if part_1_test_2[0].length != 3
raise "failed: #{part_1_test_2[1].length} does not equal 3" if part_1_test_2[1].length != 3
raise "failed: #{part_1_test_2[2].length} does not equal 3" if part_1_test_2[2].length != 3
raise "failed: #{part_1_test_2[3].length} does not equal 1" if part_1_test_2[3].length != 1
raise "failed: #{part_1_test_2[4].length} does not equal 1" if part_1_test_2[4].length != 1

part_1_test_2_sum = sum_for_all_groups('test_input_2.txt')
raise "failed: #{part_1_test_2_sum} does not equal 11" if part_1_test_2_sum != 11

# part 1
part_1 = sum_for_all_groups('input.txt')
puts "part 1: #{part_1}"
raise "failed: #{part_1} does not equal 6903" if part_1 != 6903

# part 2 tests
part_2_test = get_letters_for_groups('test_input_2.txt', everyone: true)
raise "failed: #{part_2_test[0].length} does not equal 3" if part_2_test[0].length != 3
raise "failed: #{part_2_test[1].length} does not equal 0" if part_2_test[1].length != 0
raise "failed: #{part_2_test[2].length} does not equal 1" if part_2_test[2].length != 1 # todo
raise "failed: #{part_2_test[3].length} does not equal 1" if part_2_test[3].length != 1
raise "failed: #{part_2_test[4].length} does not equal 1" if part_2_test[4].length != 1

part_2_test_sum = sum_for_all_groups('test_input_2.txt', everyone: true)
raise "failed: #{part_2_test_sum} does not equal 6" if part_2_test_sum != 6

# part 2
part_2 = sum_for_all_groups('input.txt', everyone: true)
puts "part 2: #{part_2}"
raise "failed: #{part_2} does not equal 3493" if part_2 != 3493

