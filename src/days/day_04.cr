require "../challenge"

module Days
  class Day04 < Challenge
    def part_one
      @input.each_line.count do |line|
        phrase = line.split(' ')
        phrase.size == phrase.uniq.size
      end
    end

    def part_two
      @input.each_line.count do |line|
        phrase = line.split(' ').map { |word| word.chars.sort }
        phrase.size == phrase.uniq.size
      end
    end
  end
end
