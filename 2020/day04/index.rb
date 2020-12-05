# Required fields:
# byr (Birth Year)
# iyr (Issue Year)
# eyr (Expiration Year)
# hgt (Height)
# hcl (Hair Color)
# ecl (Eye Color)
# pid (Passport ID)
# cid (Country ID) # temporarily ignored (not required now)

@required_fields = %i[byr iyr eyr hgt hcl ecl pid]

def count_valid_passports (file_name, should_validate_field_values)
  lines = File.open(file_name).readlines
  # combine lines around empties
  passport_lines = lines.slice_when { |i, j| j.strip.empty? }

  # combine separate passport lines into 1 hash
  passports = passport_lines.map do |passport_line|
    # todo - this is all pretty ugly, clean me up
    str = ''
    passport_line.each do |line|
      str = str + line.strip + ' '
    end
    pairs = str.strip.split(' ')
    password_hash = {}
    pairs.each do |pair|
      password_hash[pair.split(':')[0]] = pair.split(':')[1]
    end
    password_hash
  end

  # count valid passports
  valid_passports = passports.filter do |p|
    has_required_fields = @required_fields.all? {|f| p.key? f.to_s}
    fields_are_valid = should_validate_field_values ?
      validate_field_values(p) :
      true

    has_required_fields && fields_are_valid
  end
  valid_passports.length
end

def validate_field_values (password_hash)
  # byr (Birth Year) - four digits; at least 1920 and at most 2002.
  # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
  # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
  # hgt (Height) - a number followed by either cm or in:
  # If cm, the number must be at least 150 and at most 193.
  # If in, the number must be at least 59 and at most 76.
  # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
  # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
  # pid (Passport ID) - a nine-digit number, including leading zeroes.
  # cid (Country ID) - ignored, missing or not.

  validate_year(password_hash['byr'], 1920, 2002) &&
    validate_year(password_hash['iyr'], 2010, 2020) &&
    validate_year(password_hash['eyr'], 2020, 2030) &&
    validate_height(password_hash['hgt']) &&
    validate_hair_color(password_hash['hcl']) &&
    validate_eye_color(password_hash['ecl']) &&
    validate_pid(password_hash['pid'])
end

def validate_year (year, min, max)
  !year.nil? && !year.empty? &&
    year.length == 4 &&
    year.scan(/\D/).empty? &&
    year.to_i >= min &&
    year.to_i <= max
end

def validate_height (height)
  return false if height.nil? || height.empty?
  units = height[height.length-2..-1]
  number = height[0..height.length-3]

  if units == 'cm'
    return number.to_i >= 150 && number.to_i <= 193
  elsif units == 'in'
    return number.to_i >= 59 && number.to_i <= 76
  end

  false
end

def validate_hair_color (color)
  return /\A[#][0-9|a-f]{6}$/.match?(color)

end

def validate_eye_color (color)
  return %w[amb blu brn gry grn hzl oth].include? color
end

def validate_pid (pid)
  return /\A[0-9]{9}$/.match?(pid)
end

# part 1 tests
part_1_test = count_valid_passports('test_input.txt', false)
raise "failed: #{part_1_test} does not equal 2" if part_1_test != 2

# part 1
part_1 = count_valid_passports('input.txt', false)
puts "part 1: #{part_1}"
raise "failed: #{part_1} does not equal 237" if part_1 != 237

# part 2 tests
raise "failed: validate_year" if !validate_year('2002', 1920, 2002) == true
raise "failed: validate_year" if !validate_year('2003', 1920, 2002) == false

raise "failed: validate_height" if !validate_height('60in') == true
raise "failed: validate_height" if !validate_height('190cm') == true
raise "failed: validate_height" if !validate_height('190in') == false
raise "failed: validate_height" if !validate_height('190') == false

raise "failed: validate_hair_color" if !validate_hair_color('#123abc') == true
raise "failed: validate_hair_color" if !validate_hair_color('#123abz') == false
raise "failed: validate_hair_color" if !validate_hair_color('123abc') == false
raise "failed: validate_hair_color" if !validate_hair_color('#123abce') == false

raise "failed: validate_eye_color" if !validate_eye_color('brn') == true
raise "failed: validate_eye_color" if !validate_eye_color('wat') == false

raise "failed: validate_pid" if !validate_pid('000000001') == true
raise "failed: validate_pid" if !validate_pid('0123456789') == false

part_2_invalid_test = count_valid_passports('invalid_passwords.txt', true)
raise "failed: #{part_2_invalid_test} does not equal 0" if part_2_invalid_test != 0

part_2_valid_test = count_valid_passports('valid_passwords.txt', true)
raise "failed: #{part_2_valid_test} does not equal 4" if part_2_valid_test != 4

# part 2
part_2 = count_valid_passports('input.txt', true)
puts "part 2: #{part_2}"
raise "failed: #{part_2} does not equal 172" if part_2 != 172
