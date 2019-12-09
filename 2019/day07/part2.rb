
file = File.open("input.txt").readlines[0]
fileInput = file.split(',').map { |num| num.to_i }

# part 2 input
input1 = 0

# test data
fileInput = [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5]
# fileInput = [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10]

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


def runAmplifier(numbers, input, i, firstInput, phaseSetting)
    while i < numbers.length
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
            output = getValue(numbers, numbers[i+1], modes[0]) 
            # puts "returning with output #{output}"
            i += 2
            return [output, numbers, i]
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
            return nil
        else
            puts "uh oh, we shouldn't be here"
            raise Exception.new 'unexpected opcode'
        end
    end

    puts "hit the end"
    return nil
end

# def runAll5(input, phaseSettings)
#     puts 'running the loop'
#     output = input
#     (0..4).to_a.each do |count|
#         output = runAmplifier(output[1], output[0], output[2], phaseSettings[count])
#         break if output == nil
#     end
#     return output

#     output1 = runAmplifier(input[1], input[0], input[2], phaseSettings[0])
#     output2 = runAmplifier(output[1], output[0], input[2], phaseSettings[1])
#     output3 = runAmplifier(output[1], output[0], input[2], phaseSettings[2])
#     output4 = runAmplifier(output[1], output[0], input[2], phaseSettings[3])
#     output5 = runAmplifier(output[1], output[0], input[2], phaseSettings[4])

#     return output5
# end

def runOnRepeat(fileInput, input1, phaseSettings)
    final_output = nil
    max_output = nil
    output5 = [input1, fileInput, 0]
    continue = true
    first = true
    while continue do 
        puts "run them"
        #runAmplifier(numbers, input, i, firstInput, phaseSetting)
        #runAmplifier returns: [output, numbers, i]
        # todo - need to get input from the previous one and numbers and index from the last run of the same amp
        output1 = runAmplifier(first ? fileInput : output1[1], first ? input1 : output5[0], first ? 0 : output1[2], first, phaseSettings[0])
        output2 = runAmplifier(first ? fileInput : output2[1], output1[0], first ? 0 : output2[2], first, phaseSettings[1])
        output3 = runAmplifier(first ? fileInput : output3[1], output2[0], first ? 0 : output3[2], first, phaseSettings[2])
        output4 = runAmplifier(first ? fileInput : output4[1], output3[0], first ? 0 : output4[2], first, phaseSettings[3])
        output5 = runAmplifier(first ? fileInput : output5[1], output4[0], first ? 0 : output5[2], first, phaseSettings[4])


        first = false
        continue = false if output5 == nil
        final_output = output5 if output5 != nil
        max_output = final_output if max_output.nil? || final_output[0] > max_output[0]
    end
    return max_output
end

# max2 = 0
# maxPhaseSettings2 = nil
# [5,6,7,8,9].permutation.to_a.each do |phaseSettings|
#     output = runOnRepeat(fileInput, input1, phaseSettings)
#     puts max
#     puts output
#     if output > max
#         max = output
#         maxPhaseSettings = phaseSettings
#     end
# end

# puts "max output: #{max2}"
# puts "max phase setting combo: #{maxPhaseSettings2.to_s}"
# puts "test: #{runOnRepeat(fileInput, input1, [9,8,7,6,5])}"
puts "last output (test): #{runOnRepeat(fileInput, input1, [9,8,7,6,5])[0]}"
#puts "test: #{runOnRepeat(fileInput, input1, [9,7,8,5,6])}"
