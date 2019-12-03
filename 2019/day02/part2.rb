file = File.open("input.txt").readlines[0]

def run_program (numbers)
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
            halt = true
        else
            puts "uh oh, we shouldn't be here"
            raise Exception.new 'unexpected opcode'
        end

        i = i + 4
    end

    numbers[0]
end 

verb = 0
noun = 0
output = 0

while verb < 100 && output != 19690720
    while noun < 100 && output != 19690720
        #reset
        nums = file.split(',').map { |num| num.to_i }
        #set noun/verb
        nums[1] = noun 
        nums[2] = verb

        output = run_program(nums)
        if output == 19690720
            puts 'we did it!'
            puts 'noun: ' + noun.to_s
            puts 'verb: ' + verb.to_s
            puts 'answer: '
            puts 100 * noun + verb
        end
        noun = noun + 1
    end
    noun = 0
    verb = verb + 1
end
