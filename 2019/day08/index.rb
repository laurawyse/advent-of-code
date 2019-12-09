# for realz
digits = File.open("input.txt").readlines[0].chars.map { |num| num.to_i }
HEIGHT = 6
WIDTH = 25

#testing
# digits = "123456789012".chars.map { |num| num.to_i }
# HEIGHT = 2
# WIDTH = 3

layers = []
digit_count = 0;

while digit_count < digits.length do
    grid = Array.new(HEIGHT) { Array.new(WIDTH) { 0 } }
    zeros = 0
    ones = 0
    twos = 0

    # build each layer 
    (0..HEIGHT-1).each do |row|
        (0..WIDTH-1).each do |col|
            digit = digits[digit_count]
            grid[row][col] = digit
            digit_count += 1

            zeros += 1 if digit == 0
            ones += 1 if digit == 1
            twos += 1 if digit == 2
        end
    end

    layer = {
        grid: grid,
        zero_count: zeros,
        one_count: ones,
        two_count: twos
    }
    layers << layer
end

## PART 1 

most_zeros = nil
layer_with_most = nil

layers.each do |layer|
    if most_zeros.nil? || layer[:zero_count] < most_zeros
        most_zeros = layer[:zero_count]
        layer_with_most = layer
    end
end

## PART 1 soultion
puts "PART 1"
puts layer_with_most.to_s
puts "twos x ones = #{layer_with_most[:one_count] * layer_with_most[:two_count]}"

## PART 2

BLACK = 0
WHITE = 1
TRANSPARENT = 2
final_grid = Array.new(HEIGHT) { Array.new(WIDTH) { TRANSPARENT } }


layers.each do |layer|
    (0..HEIGHT-1).each do |row|
        (0..WIDTH-1).each do |col|
            if (final_grid[row][col] == TRANSPARENT)
                final_grid[row][col] = layer[:grid][row][col]
            end
        end
    end
end

## PART 2 solution
puts "PART 2"
final_grid.each do |row|
    puts row.to_s
end

