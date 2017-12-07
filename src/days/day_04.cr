require "../challenge"

module Days
  class Day04 < Challenge
    def part_one
      @input.each_line.count do |line|
        phrase = line.split(' ')
        valid?(phrase)
      end
    end

    def part_two
      @input.each_line.count do |line|
        phrase = line.split(' ').map { |word| word.chars.sort }
        valid?(phrase)
      end
    end

    private def valid?(phrase)
      phrase.all? do |word|
        phrase.count(word) < 2
      end
    end
  end
end
