require_relative 'intcode'

file = File.open('input.txt').readlines[0]
numbers = file.split(',').map(&:to_i)

# ==== constants ====

BLACK = 0
WHITE = 1
INSTRUCT_PAINT_BLACK = 1
INSTRUCT_PAINT_WHITE = 0
INSTRUCT_TURN_LEFT = 0
INSTRUCT_TURN_RIGHT = 1

# ==== helper functions ====

def get_current_color(points, x, y)
  if points.key?(x.to_s.to_sym) && points[x.to_s.to_sym].key?(y.to_s.to_sym)
    points[x.to_s.to_sym][y.to_s.to_sym]
  else
    BLACK
  end
end

def get_new_direction(current_direction, instruction)
  # in degrees where 0 is up, 90 is to the right, etc
  def normalize(dir)
    if dir < 0
      dir + 360
    elsif dir >= 360
      dir - 360
    else
      dir
    end
  end

  if instruction == INSTRUCT_TURN_LEFT
    normalize(current_direction - 90)
  elsif instruction == INSTRUCT_TURN_RIGHT
    normalize(current_direction + 90)
  else
    raise 'INVALID DIRECTION'
  end
end

# ==== state ====

direction_facing = 0
current_x = 0
current_y = 0

# painted_points - object showing which points have been painted and what color they are
# {
#     x: {
#         y: 0 or 1
#     }
# }
# example:
# {
#     '0': {
#         '1': 1,
#         '2': 0,
#         '3': 1
#     }
# }
painted_points = {}

# ==== solution ====

# starting state
current_color = BLACK
i = 0

# TODO - status: directions below are messed up (starts at 16th time in)
while true do
  # get the color to paint
  paint_instruction, numbers, i = run_intcode(numbers, current_color, i)
  break if paint_instruction.nil?

  # paint the current spot
  paint_color = paint_instruction == INSTRUCT_PAINT_BLACK ? BLACK : WHITE
  painted_points[current_x] = {} unless painted_points.key?(current_x)
  painted_points[current_x][current_y] = paint_color

  # get the direction to move
  turn_instruction, numbers, i = run_intcode(numbers, current_color, i)

  # turn and move the robot
  if direction_facing.zero?
    puts "NORTH, turn_instruction #{turn_instruction}"
    current_y += 1
  elsif direction_facing == 90
    puts "EAST, turn_instruction #{turn_instruction}"
    current_x += 1
  elsif direction_facing == 180
    puts "SOUTH, turn_instruction #{turn_instruction}"
    current_y -= 1
  elsif direction_facing == 270
    puts "WEST, turn_instruction #{turn_instruction}"
    current_x -= 1
  end
  direction_facing = get_new_direction(direction_facing, turn_instruction)
  current_color = paint_instruction == INSTRUCT_PAINT_BLACK ? BLACK : WHITE

  break if turn_instruction.nil?
end

# puts "count: #{count}"
# -1,0
# -0,0
# -1,0
# -1,0
# -0,1
# -1,0
# -1,0

puts painted_points.to_s

painted_count = painted_points.reduce(0) {|sum, val| sum + val.size}

puts "Total points painted: #{painted_count}"

