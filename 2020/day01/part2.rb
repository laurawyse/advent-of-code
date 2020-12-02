# real input
expenses = File.open("input.txt").readlines.map(&:to_i)

# test input
# expenses = File.open("test_input.txt").readlines.map(&:to_i)

expenses.each do |first_expense|
  expenses_part_2 = expenses.slice_after(first_expense).to_a[1].to_a
  expenses_part_2.each do |second_expense|
    expenses_part_3 = expenses_part_2.slice_after(second_expense).to_a[1].to_a
    expenses_part_3.each do |third_expense|
      if first_expense + second_expense + third_expense == 2020
        puts "#{first_expense} + #{second_expense} + #{third_expense} = 2020!!"
        puts "ANSWER: #{first_expense * second_expense * third_expense}"
      end
    end
  end
end
