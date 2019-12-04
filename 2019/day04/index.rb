# input range: 307237-769058
MIN = 307237
MAX = 769058

possible_passwords = []
possible_passwords_part2 = []

def has_adjacent_match?(num)
    match = false
    digits = num.to_s.chars.map(&:to_i)
    digits.each_with_index do |digit, index|
        next if index == digits.length - 1 
        match = true if digits[index + 1] == digits[index]
    end
    match
end

def digits_increase?(num)
    increase = true
    digits = num.to_s.chars.map(&:to_i)
    digits.each_with_index do |digit, index|
        next if index == digits.length - 1
        if digits[index + 1] < digits[index]
            increase = false 
        end
    end
    increase
end

(MIN..MAX).to_a.each do |num|
    next if num.to_s.length != 6
    next if !has_adjacent_match? num
    next if !digits_increase? num

    possible_passwords << num
end

puts 'PART 1'
puts possible_passwords
puts 'number of possibilies: ' + possible_passwords.length.to_s

## PART 2

def has_only_double_adjacent_match?(num)
    # note - this assumes the digits are in increasing or equal order
    digitCounts = {}
    digits = num.to_s.chars.map(&:to_i)
    digits.each do |digit|
        digitCounts[digit] = 0 if !digitCounts[digit]
        digitCounts[digit] += 1;
    end

    twos = digitCounts.select { |key, value| value == 2 }
    return twos != {}
end


(MIN..MAX).to_a.each do |num|
    next if num.to_s.length != 6
    next if !digits_increase? num
    next if !has_only_double_adjacent_match? num

    possible_passwords_part2 << num
end

puts 'PART 2'
puts possible_passwords_part2
puts 'number of possibilies: ' + possible_passwords_part2.length.to_s


