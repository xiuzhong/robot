# The application is a simulation of a toy robot moving on a square tabletop, of dimensions 5 units x 5 units.
class FallingError < RuntimeError
  def message
    'Will fall down'
  end
end

class NotPlacedError < RuntimeError
  def message
    'Robot not placed'
  end
end

class Table
  def initialize(dimension_x, dimension_y)
    # assume dimension_x/dimension_y are valid, > 0
    @dimension_x = dimension_x
    @dimension_y = dimension_y
  end

  def falling?(pos_x, pos_y)
    !(pos_x >= 0 && pos_x < @dimension_x &&
      pos_y >= 0 && pos_y < @dimension_y)
  end
end

class Robot
  attr_reader :pos_x, :pos_y, :facing, :table

  FACING = [:north, :east, :south, :west]

  def initialize(table)
    @table = table
  end

  def place_cmd(x, y, face)
    # assuming face is always valid one
    check_falling!(x, y)
    @pos_x, @pos_y, @facing = x, y, face
    self
  end

  def move_cmd
    check_placed!

    x, y = pos_x, pos_y
    case facing
    when :east
      x += 1
    when :west
      x -= 1
    when :north
      y += 1
    when :south
      y -= 1
    end
    check_falling!(x, y)
    @pos_x, @pos_y = x, y
    self
  end

  def left_cmd
    check_placed!
    @facing = FACING[FACING.index(facing) - 1]
    self
  end

  def right_cmd
    check_placed!
    @facing = FACING[(FACING.index(facing) + 1) % FACING.size]
    self
  end

  def report_cmd
    check_placed!
    [pos_x, pos_y, facing.to_s.upcase]
  end

  private

  def placed?
    pos_x && pos_y && facing ? true : false
  end

  def check_falling!(x, y)
    raise FallingError if table.falling?(x, y)
  end
  
  def check_placed!
    raise NotPlacedError unless placed?
  end
end
