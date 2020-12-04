
def count_trees(file_name, right, down)
  lines = File.open(file_name).readlines

  current_vertical_index = 0
  current_horizontal_index = 0
  tree_count = 0

  # step down
  until current_vertical_index > lines.length - 1
    current_line = lines[current_vertical_index]
    current_char = current_line[current_horizontal_index]

    # add to tree count if there is a tree at the current position
    if current_char == '#'
      tree_count = tree_count + 1
    end

    # move down 1, right 3
    current_vertical_index = current_vertical_index + down
    current_horizontal_index = (current_horizontal_index + right) % (lines[0].length - 1)
  end

  tree_count
end

# test part 1
test_part_1 = count_trees('test_input.txt', 3, 1)
raise "test_input failed: #{test_part_1} does not equal 7" if test_part_1 != 7

# part 1 solution
part_1 = count_trees('input.txt', 3, 1)
puts "part 1: #{part_1}"
raise "test_input failed: #{part_1} does not equal 211" if part_1 != 211

# test part 2
test_slope_1 = count_trees('test_input.txt', 1, 1)
raise "failed: #{test_slope_1} does not equal 2" if test_slope_1 != 2

test_slope_2 = count_trees('test_input.txt', 3, 1)
raise "failed: #{test_slope_2} does not equal 7" if test_slope_2 != 7

test_slope_3 = count_trees('test_input.txt', 5, 1)
raise "failed: #{test_slope_3} does not equal 3" if test_slope_3 != 3

test_slope_4 = count_trees('test_input.txt', 7, 1)
raise "failed: #{test_slope_4} does not equal 4" if test_slope_4 != 4

test_slope_5 = count_trees('test_input.txt', 1, 2)
raise "failed: #{test_slope_5} does not equal 2" if test_slope_5 != 2

test_part_2 = test_slope_1 * test_slope_2 * test_slope_3 * test_slope_4 * test_slope_5
raise "failed: #{test_part_2} does not equal 336" if test_part_2 != 336




# part 2
slope_1 = count_trees('input.txt', 1, 1)
slope_2 = count_trees('input.txt', 3, 1)
slope_3 = count_trees('input.txt', 5, 1)
slope_4 = count_trees('input.txt', 7, 1)
slope_5 = count_trees('input.txt', 1, 2)

part_2 = slope_1 * slope_2 * slope_3 * slope_4 * slope_5
puts "part 2: #{part_2}"
raise "failed: #{part_2} does not equal 3584591857" if part_2 != 3584591857
