require "../challenge"

module Days
  class Day06 < Challenge
    @banks : Array(Int32)
    @previous_states : Set(UInt64)
    @banks_count : Int32
    @loop_state : UInt64?

    def initialize(input)
      super(input)
      @banks = @input.split('\t').map(&.to_i)
      @banks_count = @banks.size
      @previous_states = Set(UInt64).new
      @cycles = 0
      @loop_state = nil
    end

    def part_one
      loop do
        redistribute!
        new_state = @banks.hash
        break if @previous_states.includes?(new_state)
        @previous_states << new_state
      end

      @cycles
    end

    def part_two
      part_one
      @cycles = 0
      @previous_states.clear
      @previous_states << @banks.hash
      part_one
    end

    private def redistribute!
      blocks, index = @banks.each_with_index.max_by do |block, index|
        { block, -index }
      end

      @banks[index] = 0
      blocks.times { |i| @banks[(index + i + 1) % @banks_count] += 1 }
      @cycles += 1
    end
  end
end
