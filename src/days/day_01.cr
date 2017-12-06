require "../challenge"

module Days
  class Day01 < Challenge
    def part_one
      sequence = @input.each_char.cycle.first(@input.size + 1)

      sequence.cons(2, reuse: true).sum do |(a, b)|
        a == b ? a.to_i : 0
      end
    end

    def part_two
      steps = @input.size / 2
      sequence = @input.each_char.cycle.first(@input.size + steps).to_a

      @input.size.times.sum do |i|
        a, b = sequence.values_at(i, i + steps)
        a == b ? a.to_i : 0
      end
    end
  end
end
