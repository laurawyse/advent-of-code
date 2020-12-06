def find_seat_row(code)
  rows = (0..127).to_a

  code.each_char do |c|
    if c == 'F'
      rows = rows[0..rows.length/2-1]
    elsif c == 'B'
      rows = rows[rows.length/2..rows.length]
    end
  end

  raise 'uh oh! this shouldn\'t happen' if rows.length != 1

  rows[0]
end

def find_seat_column(code)
  columns = (0..7).to_a

  code.each_char do |c|
    if c == 'L'
      columns = columns[0..columns.length/2-1]
    elsif c == 'R'
      columns = columns[columns.length/2..columns.length]
    end
  end

  raise 'uh oh! this shouldn\'t happen' if columns.length != 1

  columns[0]
end

def calculate_seat_id(code)
  find_seat_row(code) * 8 + find_seat_column(code)
end

def find_highest_seat_id(file_name)
  seats = File.open(file_name).readlines

  seats.map {|seat| calculate_seat_id(seat) }.max
end

def find_missing_seat_id(file_name)
  seat_codes = File.open(file_name).readlines

  # start with an empty seat map
  seat_map = (0..127).map do |row|
    (0..7).map do |col|
      nil
    end
  end

  # fill the seat map
  seat_codes.each do |seat_code|
    row = find_seat_row(seat_code)
    col = find_seat_column(seat_code)
    seat_map[row][col] = 'FULL'
  end

  missing_seat_row = nil
  missing_seat_column = nil

  # remove any empty rows
  seat_map.delete([nil, nil, nil, nil, nil, nil, nil, nil])

  seat_map.each_with_index do |row, index|
    nil_count = row.count(nil)
    if nil_count == 1 && row.find_index(nil) != 0 && row.find_index(nil) != 7
      # This is the one, but this check won't catch all cases. It will only find those where the
      # the missing seat is not in the first or last seated row and is not in a window seat.
      missing_seat_row = index
      missing_seat_column = row.find_index(nil)
      puts "found missing seat! missing_seat_row: #{missing_seat_row}, missing_seat_column: #{missing_seat_column}"
    end
  end

  raise 'no missing seat found' if missing_seat_row.nil? || missing_seat_column.nil?
  return missing_seat_row * 8 + missing_seat_column
end

# part 1 tests
part_1_test_1 = calculate_seat_id('FBFBBFFRLR')
raise "failed: #{part_1_test_1} does not equal 357" if part_1_test_1 != 357

part_1_test_2 = calculate_seat_id('BFFFBBFRRR')
raise "failed: #{part_1_test_2} does not equal 567" if part_1_test_2 != 567

part_1_test_3 = calculate_seat_id('FFFBBBFRRR')
raise "failed: #{part_1_test_3} does not equal 119" if part_1_test_3 != 119

part_1_test_4 = calculate_seat_id('BBFFBBFRLL')
raise "failed: #{part_1_test_4} does not equal 820" if part_1_test_4 != 820

# part 1
part_1 = find_highest_seat_id('input.txt')
puts "part 1: #{part_1}"
raise "failed: #{part_1} does not equal 908" if part_1 != 908

# part 2 tests
part_2 = find_missing_seat_id('input.txt')
puts "part 2: #{part_2}"
