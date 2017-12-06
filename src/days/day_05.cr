require "../challenge"

module Days
  class Day05 < Challenge
    @instructions : Array(Int32)
    @last_index : Int32

    def initialize(input)
      super(input)
      @instructions = @input.each_line.map(&.to_i).to_a
      @last_index = @instructions.size - 1
      @pc = 0
      @steps = 0
    end

    def part_one
      until escaped?
        next_pc = @pc + @instructions[@pc]
        @instructions[@pc] += 1
        @pc = next_pc
        @steps += 1
      end

      @steps
    end

    def part_two
      until escaped?
        offset = @instructions[@pc]
        next_pc = @pc + offset
        @instructions[@pc] += offset < 3 ? 1 : -1
        @pc = next_pc
        @steps += 1
      end

      @steps
    end

    private def escaped?
      @pc < 0 || @pc > @last_index
    end
  end
end
