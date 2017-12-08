require "../challenge"

module Days
  class Day08 < Challenge
    COND_MATCHER = /if (?<cond_left>\w+) (?<cond_op>.{1,2}) (?<cond_right>-?\d+)/
    MATCHER = /^(?<dest>\w+) (?<op>inc|dec) (?<offset>-?\d+) #{COND_MATCHER}$/

    def initialize(input)
      super(input)
      @registers = {} of String => Int32
    end

    @[AlwaysInline]
    def read(address)
      @registers.fetch(address, 0)
    end

    @[AlwaysInline]
    def inc(address, offset)
      @registers[address] = read(address) + offset
    end

    @[AlwaysInline]
    def dec(address, offset)
      inc(address, -offset)
    end

    @[AlwaysInline]
    def cond(left, op, right)
      {% begin %}
      case(op)
      {% for op in %w( < <= > >= == != ) %}
      when {{op}} then read(left) {{op.id}} right.to_i
      {% end %}
      else raise "Invalid condition operation #{op}"
      end
      {% end %}
    end

    def execute(dest, op, offset)
      case op
      when "inc" then inc(dest, offset.to_i)
      when "dec" then dec(dest, offset.to_i)
      else raise "Invalid operation #{op}"
      end
    end

    def run_instructions
      @input.each_line do |line|
        dest, op, offset, _, cond_left, cond_op, cond_right = line.split(' ')
        next unless cond(cond_left, cond_op, cond_right)
        value =  execute(dest, op, offset)
        yield value
      end
    end

    def run_instructions
      run_instructions {}
    end

    def part_one
      run_instructions
      @registers.max_of { |register, value| value }
    end

    def part_two
      highest_value = Int32::MIN

      run_instructions do |value|
        highest_value = value if value > highest_value
      end

      highest_value
    end
  end
end
