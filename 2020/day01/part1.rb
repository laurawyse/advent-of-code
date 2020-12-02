# real input
expenses = File.open("input.txt").readlines.map(&:to_i)

# test input
# expenses = File.open("test_input.txt").readlines.map(&:to_i)

expenses.each do |first_expense|
  rest_of_expenses = expenses.slice_after(first_expense).to_a[1].to_a
  rest_of_expenses.each do |second_expense|
    if first_expense + second_expense == 2020
      puts "#{first_expense} + #{second_expense} = 2020!!"
      puts "ANSWER: #{first_expense * second_expense}"
    end
  end
end
