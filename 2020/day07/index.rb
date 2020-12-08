BagRule = Struct.new(:outside_bag_type, :inside_bag_type, :inside_bag_count)

# builds a list of BagRules
def build_bag_rules(file_name)
  lines = File.open(file_name).readlines
  bag_rules = []

  lines.each do |line|
    outside_bag_type = line[/^(.*) bags contain/, 1]

    inside_rules_strings = line[/^.* bags contain (.*)./, 1].split(',').map(&:strip)

    inside_rules_strings.each do |inside_bag_rule|
      break if inside_bag_rule == 'no other bags'
      inside_bag_type = inside_bag_rule[/^\d* (.*) bag/, 1]
      inside_bag_count = inside_bag_rule[/^(\d*) .*/, 1]

      bag_rules << BagRule.new(outside_bag_type, inside_bag_type, inside_bag_count.to_i)
    end
  end

  bag_rules
end

# finds a list of bags that can contain bag_type
def find_bags_containing(bag_rules, bag_type)
  valid_bags = [] # list of bags that can contain bag_type
  current_rules = bag_rules.select { |bag_rule| bag_rule.inside_bag_type == bag_type }

  current_rules.map do |rule|
    valid_bags << rule.outside_bag_type
    valid_bags.concat(find_bags_containing(bag_rules, rule.outside_bag_type))
  end

  valid_bags.uniq
end

# returns a count of all bags inside bag_type
def count_bags_inside(bag_rules, bag_type)
  inside_bag_count = 0
  current_rules = bag_rules.select { |bag_rule| bag_rule.outside_bag_type == bag_type }

  if current_rules.length == 0
    return inside_bag_count
  end

  current_rules.map do |rule|
    # count the inside bags
    inside_bag_count = inside_bag_count + rule.inside_bag_count
    # count all the bags inside the inside bags
    inside_bag_count = inside_bag_count + rule.inside_bag_count * count_bags_inside(bag_rules, rule.inside_bag_type)
  end

  inside_bag_count
end

# part 1 test
part_1_test = find_bags_containing(build_bag_rules("test_input.txt"), 'shiny gold').length
raise "failed: #{part_1_test} does not equal 4" if part_1_test != 4

# part 1
part_1 = find_bags_containing(build_bag_rules("input.txt"), 'shiny gold').length
puts "part_1: #{part_1}"
raise "failed: #{part_1} does not equal 119" if part_1 != 119

# part 2 test
part_2_test_1 = count_bags_inside(build_bag_rules("test_input.txt"), 'shiny gold')
raise "failed: #{part_2_test_1} does not equal 32" if part_2_test_1 != 32

part_2_test_2 = count_bags_inside(build_bag_rules("test_input_2.txt"), 'shiny gold')
raise "failed: #{part_2_test_2} does not equal 126" if part_2_test_2 != 126

# part 1
part_2 = count_bags_inside(build_bag_rules("input.txt"), 'shiny gold')
puts "part_2: #{part_2}"
raise "failed: #{part_2} does not equal 155802" if part_2 != 155802
