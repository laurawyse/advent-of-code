rows = File.open("input.txt").readlines.map(&:chomp)
grid = rows.map(&:chars)

# build a list of asteroids
all_asteroids = []
(0..grid.length-1).to_a.each do |y|
  (0..grid[y].length-1).to_a.each do |x|
    all_asteroids.push(x: x, y: y) if grid[y][x] == '#'
  end
end

def find_visible_asteroids (asteroids, current_asteroid)
  angles = []
  visible_asteroids = []

  asteroids.map do |a|
    delta_x = current_asteroid[:x] - a[:x]
    delta_y = current_asteroid[:y] - a[:y]

    next if delta_x.zero? && delta_y.zero?

    angle = Math.atan2(delta_y, delta_x) * 180 / Math::PI - 90
    angle += 360 if angle < 360
    angle -= 360 if angle > 360
    angle = 0.0 if angle == 360

    if angles.include?(angle)
      # choose the closer one
      existing = visible_asteroids.find { |a| a[:angle] == angle }
      current_dist = Math.sqrt(delta_x**2 + delta_y**2)
      existing_dist = Math.sqrt((current_asteroid[:x] - existing[:x])**2 + (current_asteroid[:y] - existing[:y])**2)
      if current_dist < existing_dist
        visible_asteroids.delete(existing)
        visible_asteroids.push(a.merge({angle: angle}))
      end
    else
      angles.push(angle)
      visible_asteroids.push(a.merge({angle: angle}))
    end
  end

  visible_asteroids
end

# add a count of how many other asteroids that asteroid can see
asteroids_with_count = all_asteroids.map do |current_asteroid|
  # for each asteroid, see how many unique angles there are
  {
    x: current_asteroid[:x],
    y: current_asteroid[:y],
    count: find_visible_asteroids(all_asteroids, current_asteroid).length
  }
end

winner_winner = asteroids_with_count.reduce(nil) do |winner, asteroid|
  if winner.nil? || asteroid[:count] > winner[:count]
    asteroid
  else
    winner
  end
end

puts "Part 1 solution: #{winner_winner[:count]}"

# spin around and destroy all the asteroids
visible_asteroids = find_visible_asteroids(all_asteroids, winner_winner).sort_by{ |a| a[:angle] }
destroyed_count = 0
round = 1
two_hundredth = nil
puts 'first time around ....'
while visible_asteroids.length > 0
  visible_asteroids.each do |a|
    all_asteroids.delete({x: a[:x], y: a[:y]})
    destroyed_count += 1
    if destroyed_count == 200
      puts "The 200th asteroid to be destroyed: #{a.to_s}"
      two_hundredth = a
    end
  end

  visible_asteroids = find_visible_asteroids(all_asteroids, winner_winner).sort_by{ |a| a[:angle] }
  puts "round #{round} complete"
  round += 1
end

puts "Part 2 solution: #{two_hundredth[:x] * 100 + two_hundredth[:y]}"
