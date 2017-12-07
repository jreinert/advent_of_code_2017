require "../challenge"

module Days
  class Day06 < Challenge
    @banks : Array(Int32)
    @previous_states : Set(UInt64)

    def initialize(input)
      super(input)
      @banks = @input.split('\t').map(&.to_i)
      @previous_states = Set(UInt64).new
    end

    def part_one
      loop do
        redistribute!
        new_state = @banks.hash
        break if @previous_states.includes?(new_state)
        @previous_states << new_state
      end

      @previous_states.size + 1
    end

    def part_two
      part_one
      @previous_states.clear
      @previous_states << @banks.hash
      part_one - 1
    end

    private def redistribute!
      blocks, index = @banks.each_with_index.max_by do |block, index|
        { block, -index }
      end

      @banks[index] = 0
      blocks.times { |i| @banks[(index + i + 1) % @banks.size] += 1 }
    end
  end
end
