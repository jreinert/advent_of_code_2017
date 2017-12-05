require "benchmark"

PUZZLE_INPUT = STDIN.gets_to_end.to_u64

class SpiralIterator
  include Iterator(UInt64)

  DIRECTIONS = [:right, :up, :left, :down].cycle
  @direction : (Symbol | Iterator::Stop)

  def initialize
    @position = 1_u64
    @x = 0_i64
    @y = 0_i64
    @direction = DIRECTIONS.next
    @last_steps_to_corner = 1_u64
    @steps_to_corner = 1_u64
    @corners_until_increase = 2_u64
  end

  def next
    result = @x.abs + @y.abs

    @position += 1
    @steps_to_corner -= 1

    set_coordinates
    set_direction

    result.to_u64
  end

  private def set_coordinates
    case @direction
    when :right then @x += 1
    when :up then @y += 1
    when :left then @x -= 1
    when :down then @y -= 1
    end
  end

  private def set_direction
    return unless @steps_to_corner.zero?

    @direction = DIRECTIONS.next
    @corners_until_increase -= 1

    if @corners_until_increase.zero?
      @last_steps_to_corner += 1
      @corners_until_increase = 2_u64
    end

    @steps_to_corner = @last_steps_to_corner
  end
end

class SpiralIterator2 < SpiralIterator
  def initialize
    super
    @fields = { { 0_i64, 0_i64 } => 1_u64 }
  end

  def next
    position = { @x, @y }
    super
    @fields[position] = summed_neighbors(position)
  end

  private def summed_neighbors(position)
    neighboring_fields(position).sum do |coordinates|
      @fields.fetch(coordinates, 0_u64)
    end
  end

  private def neighboring_fields(position)
    x, y = position
    [
      { x - 1, y + 1 }, { x, y + 1 }, { x + 1, y + 1 },
      { x - 1, y     }, { x, y     }, { x + 1, y     },
      { x - 1, y - 1 }, { x, y - 1 }, { x + 1, y - 1 }
    ]
  end
end

def part_one(input)
  SpiralIterator.new.skip(input - 1).next
end

def part_two(input)
  SpiralIterator2.new.find { |result| result > input }
end

puts case ARGV[0]
when "1" then part_one(PUZZLE_INPUT)
when "2" then part_two(PUZZLE_INPUT)
end
