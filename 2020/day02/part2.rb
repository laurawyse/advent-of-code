# Password
Password = Struct.new(:index1, :index2, :char, :password)

# passwords = File.open("test_input.txt").readlines.map do |password| # test input
passwords = File.open("input.txt").readlines.map do |password| # real input
  index1 = password.split('-')[0].to_i - 1
  index2 = password.split('-')[1].split(' ')[0].to_i - 1
  char = password.split(' ')[1].split(':')[0]
  p = password.split(': ')[1]
  Password.new(index1, index2, char, p)
end

valid_count = 0

passwords.each do |p|
  char_at_index1 = p.password[p.index1]
  char_at_index2 = p.password[p.index2]
  if (char_at_index1 == p.char || char_at_index2 == p.char) && !(char_at_index1 == p.char && char_at_index2 == p.char)
    valid_count = valid_count + 1
  end
end

puts "Valid password count: #{valid_count}"
