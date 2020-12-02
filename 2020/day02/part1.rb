# Password
Password = Struct.new(:min, :max, :char, :password)

# passwords = File.open("test_input.txt").readlines.map do |password| # test input
passwords = File.open("input.txt").readlines.map do |password| # real input
  min = password.split('-')[0].to_i
  max = password.split('-')[1].split(' ')[0].to_i
  char = password.split(' ')[1].split(':')[0]
  p = password.split(': ')[1]
  Password.new(min, max, char, p)
end

valid_count = 0

passwords.each do |p|
  char_count = p.password.count(p.char)
  if char_count >= p.min && char_count <= p.max
    valid_count = valid_count + 1
  end
end

puts "Valid password count: #{valid_count}"
