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

# solve
sacks = File.open("input.txt").readlines
# test
# sacks = File.open("test_input.txt").readlines

score = sacks.reduce(0) do |sum, sack|
    compartment_1, compartment_2 = sack.chars.each_slice(sack.length / 2).map(&:to_a)
    compartment_1, compartment_2 = sack.chars.each_slice(sack.length / 2).map(&:to_a)
    intersection = (compartment_1 & compartment_2).first
    sum + key[intersection]
end

puts "ANSWER: #{score}"