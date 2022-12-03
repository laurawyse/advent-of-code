# build key which will look like: 
# {
#     'a': 1,
#     'b': 2,
#     ...
#     'A': 27,
#     ...
#     'Z': 52
# }
letters = ("a".."z").to_a + ("A".."Z").to_a
key = {}
value = 1
letters.each do |letter|
    key[letter] = value
    value = value + 1
end

sacks = File.open("input.txt").readlines
# test
# sacks = File.open("test_input.txt").readlines

# group by 3s
groups = sacks.each_slice(3).to_a

# solve
score = groups.reduce(0) do |sum, group|
    badge = (group[0].chars & group[1].chars & group[2].chars).first
    sum + key[badge]
end

puts "ANSWER: #{score}"