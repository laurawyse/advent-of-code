file = File.open("input.txt").readlines[0]
numbers = file.split(',').map { |num| num.to_i }

# restore to 1202
numbers[1] = 12
numbers[2] = 2

# test data
# numbers = [1,1,1,4,99,5,6,0,99]

i = 0
halt = false
while i < numbers.length && !halt
    current = numbers[i]
    if current.to_i == 1
        inputIndexA = numbers[i+1]
        inputIndexB = numbers[i+2]
        outputIndex = numbers[i+3]

        numbers[outputIndex] = numbers[inputIndexA] + numbers[inputIndexB]
    elsif current.to_i == 2
        inputIndexA = numbers[i+1]
        inputIndexB = numbers[i+2]
        outputIndex = numbers[i+3]

        numbers[outputIndex] = numbers[inputIndexA] * numbers[inputIndexB]
    elsif current.to_i == 99
        puts "99! we\'re all done here"
        halt = true
    else
        puts "uh oh, we shouldn't be here"
        raise Exception.new 'unexpected opcode'
    end

    i = i + 4
end

puts numbers[0]