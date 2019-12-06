file = File.open("input.txt").readlines[0]
numbers = file.split(',').map { |num| num.to_i }

# restore to 1202
# numbers[1] = 12
# numbers[2] = 2

# test data
# numbers = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]

# PART 1 input
# input = 1

# PART 2 input
input = 5

def getValue(numbers, num, mode)
    if mode == 0
        # position mode (original method)
        return numbers[num]
    elsif mode == 1
        # immediate mode
        return num
    else
        puts 'uh oh'
    end
end

def getOpcode(entireInstruction) 
    if entireInstruction.to_s.length <= 2
        entireInstruction
    else
        entireInstruction.to_s[entireInstruction.to_s.length - 2, 2].to_i
    end
end

def getModes(entireInstruction)
    if entireInstruction.to_s.length <= 2
        [0, 0]
    else
        ms = entireInstruction.to_s.chars.reverse().slice(2, entireInstruction.to_s.length - 2).map(&:to_i)
        if ms.size == 1
            ms.push(0)
        end
        ms
    end
end


i = 0
halt = false
while i < numbers.length && !halt
    entireInstruction = numbers[i]
    current = getOpcode(entireInstruction)
    modes = getModes(entireInstruction)

    if current.to_i == 1
        inputValueA = getValue(numbers, numbers[i+1], modes[0])
        inputValueB = getValue(numbers, numbers[i+2], modes[1])
        outputIndex = numbers[i+3]
        
        numbers[outputIndex] = inputValueA + inputValueB
        i += 4
    elsif current.to_i == 2
        inputValueA = getValue(numbers, numbers[i+1], modes[0])
        inputValueB = getValue(numbers, numbers[i+2], modes[1])
        outputIndex = numbers[i+3]
    
        numbers[outputIndex] = inputValueA * inputValueB
        i += 4
    elsif current.to_i == 3
        outputIndex = numbers[i+1]

        numbers[outputIndex] = input
        i += 2
    elsif current.to_i == 4
        outputIndex = numbers[i+1]
        output = getValue(numbers, numbers[i+1], modes[0])
        puts output
        i += 2
    elsif current.to_i == 5
        if getValue(numbers, numbers[i+1], modes[0]) != 0
            i = getValue(numbers, numbers[i+2], modes[1])
        else
            i += 3
        end
    elsif current.to_i == 6
        if getValue(numbers, numbers[i+1], modes[0]) == 0
            i = getValue(numbers, numbers[i+2], modes[1])
        else
            i += 3
        end
    elsif current.to_i == 7
        if getValue(numbers, numbers[i+1], modes[0]) < getValue(numbers, numbers[i+2], modes[1])
            numbers[numbers[i+3]] = 1
        else
            numbers[numbers[i+3]] = 0
        end
        i += 4
    elsif current.to_i == 8
        if getValue(numbers, numbers[i+1], modes[0]) == getValue(numbers, numbers[i+2], modes[1])
            numbers[numbers[i+3]] = 1
        else
            numbers[numbers[i+3]] = 0
        end
        i += 4
    elsif current.to_i == 99
        puts "99! we\'re all done here"
        halt = true
        i += 4
    else
        puts "uh oh, we shouldn't be here"
        puts current
        raise Exception.new 'unexpected opcode'
    end
end

puts numbers.to_s