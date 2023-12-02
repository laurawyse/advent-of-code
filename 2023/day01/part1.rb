# real input
lines = File.open("input.txt").readlines

# test input
# lines = File.open("test_input.txt").readlines


# team
lines.each do |line|
  line_without_chars = line.gsub(/\D/, '')
  # puts line_without_chars
end


# mine

def first_last_number(str)
  str.gsub(/\D/, '')
    .split('')
    .values_at(0,-1)
    .join
    .to_i
end

values = []

lines.each do |line|
  values << first_last_number(line)
end

puts "ANSWER: #{values.sum}"
