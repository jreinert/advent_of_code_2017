require "../challenge"

module Days
  class Day02 < Challenge
    def part_one
      sum_each_row do |cells|
        min, max = cells.minmax
        max - min
      end
    end

    def part_two
      sum_each_row do |cells|
        combinations = cells.each_combination(2, reuse: true).map(&.sort)
        divisor, divident = combinations.find({ 0, 0 }) do |(a, b)|
          b % a == 0
        end

        divident / divisor
      end
    end

    private def sum_each_row
      @input.each_line.sum do |line|
        cells = line.split('\t')
        yield cells.map(&.to_i)
      end
    end
  end
end
