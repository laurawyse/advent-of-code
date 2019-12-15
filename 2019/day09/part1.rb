file = File.open('input.txt').readlines[0]
numbers = file.split(',').map(&:to_i)

# test data
# numbers = [104,1125899906842624,99]
input = 1

def get_value(numbers, num, mode, base)
  if mode.zero?
    # position mode (original method)
    numbers[num] || 0
  elsif mode == 1
    # immediate mode
    num
  elsif mode == 2
    # relative mode
    numbers[num + base] || 0
  else
    puts 'INVALID MODE'
  end
end

def get_opcode(entire_instruction)
  if entire_instruction.to_s.length <= 2
    entire_instruction
  else
    entire_instruction.to_s[entire_instruction.to_s.length - 2, 2].to_i
  end
end

def get_modes(entire_instruction)
  if entire_instruction.to_s.length <= 2
    [0, 0, 0]
  else
    ms = entire_instruction.to_s.chars.reverse.slice(2, entire_instruction.to_s.length - 2).map(&:to_i)
    ms.push(0) if ms.size == 1
    ms.push(0) if ms.size == 2
    ms
  end
end

def change_number(numbers, new_value, index)
  puts 'INVALID INDEX' if index.negative?
  if index >= numbers.length
    (numbers.length..index).to_a.each { numbers.push(0) }
  end
  numbers[index] = new_value
  numbers
end

i = 0
halt = false
base = 0
while i < numbers.length && !halt
  entire_instruction = numbers[i]
  current = get_opcode(entire_instruction).to_i
  modes = get_modes(entire_instruction)

  param1 = get_value(numbers, numbers[i + 1], modes[0], base)
  param2 = get_value(numbers, numbers[i + 2], modes[1], base)
  param3 = get_value(numbers, numbers[i + 3], modes[2], base)

  case current
  when 1
    numbers = change_number(numbers, param1 + param2, param3)
    i += 4
  when 2
    # seems like there is something wrong here...
    numbers = change_number(numbers, param1 * param2, param3)
    i += 4
  when 3
    numbers = change_number(numbers, input, param1)
    i += 2
  when 4
    output = param1
    puts output
    i += 2
  when 5
    if param1 != 0
      i = param2
    else
      i += 3
    end
  when 6
    if param1.zero?
      i = param2
    else
      i += 3
    end
  when 7
    if param1 < param2
      numbers = change_number(numbers, 1, param3)
    else
      numbers = change_number(numbers, 0, param3)
    end
    i += 4
  when 8
    if param1 == param2
      numbers = change_number(numbers, 1, param3)
    else
      numbers = change_number(numbers, 0, param3)
    end
    i += 4
  when 9
    base += param1
    i += 2
  when 99
    puts 'OPCODE 99: status complete'
    halt = true
    i += 4
  else
    puts 'INVALID OPCODE'
  end
end

puts numbers.to_s
