rows = File.open("input.txt").readlines.map(&:chomp)

# position and velocity are both Coords
Moon = Struct.new(:name, :position, :velocity) do
  def potential_energy
    position[:x].abs() + position[:y].abs() + position[:z].abs()
  end

  def kinetic_energy
    velocity[:x].abs() + velocity[:y].abs() + velocity[:z].abs()
  end

  def to_s
    # Name:pos=<x=-1,y=0,z=2>,vel=<x=0,y=0,z=0>
    "#{name}:pos=<x=#{position[:x]},y=#{position[:y]},z=#{position[:z]}>,vel=<x=#{velocity[:x]},y=#{velocity[:y]},z=#{velocity[:z]}>"
  end
end
Coord = Struct.new(:x, :y, :z)
Change = Struct.new(:moon_name, :dimension, :change)


# ==== setup ====
names = %i(Io Europa Ganymede Callisto)
name_count = 0
moons = rows.map do |r|
  coords = r[1, r.length - 1].chop.split(',')
  x = coords[0].strip()[2,coords[0].strip().length].to_i
  y = coords[1].strip()[2,coords[1].strip().length].to_i
  z = coords[2].strip()[2,coords[2].strip().length].to_i
  moon = Moon.new(names[name_count], Coord.new(x, y, z), Coord.new(0, 0, 0))
  name_count = name_count + 1
  moon
end

# ==== helpers ====

def get_gravity_changes(moon_a, moon_b)
  changes = []
  # changes for x
  if moon_a[:position][:x] > moon_b[:position][:x]
    changes << Change.new(moon_a[:name], 'x', -1)
    changes << Change.new(moon_b[:name], 'x', 1)
  elsif moon_a[:position][:x] < moon_b[:position][:x]
    changes << Change.new(moon_a[:name], 'x', 1)
    changes << Change.new(moon_b[:name], 'x', -1)
  end

  # changes for y
  if moon_a[:position][:y] > moon_b[:position][:y]
    changes << Change.new(moon_a[:name], 'y', -1)
    changes << Change.new(moon_b[:name], 'y', 1)
  elsif moon_a[:position][:y] < moon_b[:position][:y]
    changes << Change.new(moon_a[:name], 'y', 1)
    changes << Change.new(moon_b[:name], 'y', -1)
  end

  # changes for z
  if moon_a[:position][:z] > moon_b[:position][:z]
    changes << Change.new(moon_a[:name], 'z', -1)
    changes << Change.new(moon_b[:name], 'z', 1)
  elsif moon_a[:position][:z] < moon_b[:position][:z]
    changes << Change.new(moon_a[:name], 'z', 1)
    changes << Change.new(moon_b[:name], 'z', -1)
  end

  changes
end

# applies gravity (aka adjusts the velocity)
def apply_gravity_change(moon, change)
  return moon unless moon[:name] == change[:moon_name]
  if change[:dimension] == 'x'
    Moon.new(moon[:name], moon[:position], Coord.new(moon[:velocity][:x] + change[:change], moon[:velocity][:y], moon[:velocity][:z]))
  elsif change[:dimension] == 'y'
    Moon.new(moon[:name], moon[:position], Coord.new(moon[:velocity][:x], moon[:velocity][:y] + change[:change], moon[:velocity][:z]))
  elsif change[:dimension] == 'z'
    Moon.new(moon[:name], moon[:position], Coord.new(moon[:velocity][:x], moon[:velocity][:y], moon[:velocity][:z] + change[:change]))
  end
end

# applies velocity ()aka adjusts the position) - tested
def apply_velocity(moon)
  new_x_pos = moon[:position][:x] + moon[:velocity][:x]
  new_y_pos = moon[:position][:y] + moon[:velocity][:y]
  new_z_pos = moon[:position][:z] + moon[:velocity][:z]
  Moon.new(moon[:name], Coord.new(new_x_pos, new_y_pos, new_z_pos), Coord.new(moon[:velocity][:x], moon[:velocity][:y], moon[:velocity][:z]))
end

# strinifies a list of moons to the format:
# "Name:pos=<x=-1,y=0,z=2>,vel=<x=0,y=0,z=0>,
def stringify_moon_list(moons)
  moons.map { |moon| moon.to_s }.to_s
  # moons.to_s
end

# ==== do it to it ====

# simulate in time steps

time_step = 1
history = {} # {moons_string: true}

# puts 'before:'
# puts moons
while true
  puts "time step: #{time_step}"
  # update velocity by applying gravity (to all moons)
  # - find changes to be applied based on each pair of moons
  changes = []
  moons.combination(2).to_a.each do |moon_pair|
    cs = get_gravity_changes(moon_pair[0], moon_pair[1])
    changes = changes + cs
  end
  # - apply the changes to the moons
  io, europa, ganymede, callisto = nil, nil, nil, nil

  moons.each do |moon|
    io = moon if moon[:name] == :Io
    europa = moon if moon[:name] == :Europa
    ganymede = moon if moon[:name] == :Ganymede
    callisto = moon if moon[:name] == :Callisto
  end
  changes.each do |change|
    io = apply_gravity_change(io, change) if change[:moon_name] == :Io
    europa = apply_gravity_change(europa, change) if change[:moon_name] == :Europa
    ganymede = apply_gravity_change(ganymede, change) if change[:moon_name] == :Ganymede
    callisto = apply_gravity_change(callisto, change) if change[:moon_name] == :Callisto
  end
  moons = [io, europa, ganymede, callisto]

  # update position by applying velocity (to all moons)
  moons = moons.map { |moon| apply_velocity(moon) }

  # see if this moon positions/velocities combination has happened before
  if (!history[stringify_moon_list(moons)].nil?)
    puts 'found a match!'
    break
  end

  # puts stringify_moon_list(moons)
  # add this list of moon positions/velocities to the list
  history[stringify_moon_list(moons)] = true
  time_step = time_step + 1
end

puts "Part 2 solution: #{time_step-1}"
puts "Part 2 expected: 4686774924"

# 4686774924
