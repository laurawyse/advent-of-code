POSITION_MODE = 0
IMMEDIATE_MODE = 1
RELATIVE_MODE = 2

def run_intcode(numbers, input, i)
  halt = false
  base = 0
  while i < numbers.length && !halt
    entire_instruction = numbers[i]
    current = get_opcode(entire_instruction).to_i
    modes = get_modes(entire_instruction)

    param1 = get_value(numbers, numbers[i + 1], modes[0], base)
    param2 = get_value(numbers, numbers[i + 2], modes[1], base)
    param3 = get_write_index(mode: modes[2], index: i+3, base: base, numbers: numbers)

    # if (param3 == 10)
    #     puts 'uh oh'
    # end

    # puts current
    case current
    when 1
      change_number(numbers, param1 + param2, param3)
      i += 4
    when 2
      # seems like there is something wrong here...
      change_number(numbers, param1 * param2, param3)
      i += 4
    when 3
      # for 3, param1 is a write param so we need to get it using that function
      three_index = get_write_index(mode: modes[0], index: i+1, base: base, numbers: numbers)
      if (three_index == 10)
        puts 'uh oh'
      end
      change_number(numbers, input, three_index)
      i += 2
    when 4 # soemthing is wrong at spot 10, its 1 and should be 0
      output = param1
      i += 2
      # puts "output: #{output}, i: #{i}, base: #{base}, numbers[i]: #{numbers[i]}"
      return output, numbers, i
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
        change_number(numbers, 1, param3)
      else
        change_number(numbers, 0, param3)
      end
      i += 4
    when 8
      if param1 == param2
        change_number(numbers, 1, param3)
      else
        change_number(numbers, 0, param3)
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
      raise 'INVALID OPCODE'
    end
  end

  [nil, numbers, i]
end

private
# ?, 121, -, -
def get_value(numbers, index, mode, base)
  case mode
  when POSITION_MODE
    numbers[index] || 0
  when IMMEDIATE_MODE
    index
  when RELATIVE_MODE
    numbers[index + base] || 0
  else
    raise 'INVALID MODE'
  end
end

def get_write_index(mode:, index:, base:, numbers:)
  case mode
  when RELATIVE_MODE
    numbers[index] + base
  when POSITION_MODE
    numbers[index]
  else
    raise 'INVALID MODE'
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
  raise 'INVALID INDEX' if index.negative?
  if index >= numbers.length
    (numbers.length..index).to_a.each { numbers.push(0) }
  end
  numbers[index] = new_value
end
