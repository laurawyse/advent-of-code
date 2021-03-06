
file = File.open("input.txt").readlines[0]
fileInput = file.split(',').map { |num| num.to_i }

# part 1 input
input1 = 0

# test data
# fileInput = [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5]


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


def runAmplifier(numbers, input, phaseSetting)
    output = nil
    i = 0
    halt = false
    firstInput = true;
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

            numbers[outputIndex] = firstInput ? phaseSetting : input
            firstInput = false
            i += 2
        elsif current.to_i == 4
            outputIndex = numbers[i+1]
            output = getValue(numbers, numbers[i+1], modes[0])
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
            # puts "99! we\'re all done here"
            halt = true
            i += 4
        else
            puts "uh oh, we shouldn't be here"
            raise Exception.new 'unexpected opcode'
        end
    end
    return output
end

def runAll5(fileInput, input1, phaseSettings)
    output1 = runAmplifier(fileInput.dup, input1, phaseSettings[0])
    output2 = runAmplifier(fileInput.dup, output1, phaseSettings[1])
    output3 = runAmplifier(fileInput.dup, output2, phaseSettings[2])
    output4 = runAmplifier(fileInput.dup, output3, phaseSettings[3])
    return runAmplifier(fileInput.dup, output4, phaseSettings[4])
end


max = 0
maxPhaseSettings = nil
[0,1,2,3,4].permutation.to_a.each do |phaseSettings|
    output = runAll5(fileInput, input1, phaseSettings)
    puts max
    puts output
    if output > max
        max = output
        maxPhaseSettings = phaseSettings
    end
end

puts "max output: #{max}"
puts "max phase setting combo: #{maxPhaseSettings.to_s}"

