require "../challenge"

module Days
  class Day09 < Challenge
    def initialize(input)
      super(input)
      @total_score = 0
      @depth = 0
      @garbage = false
      @cancelled = false
      @garbage_count = 0
    end

    @[AlwaysInline]
    def parse(char)
      case char
      when '{' then @depth += 1
      when '}'
        @total_score += @depth
        @depth -= 1
      when '<' then @garbage = true
      end
    end

    @[AlwaysInline]
    def parse_garbage(char)
      return @cancelled = false if @cancelled

      case char
      when '!' then @cancelled = true
      when '>' then @garbage = false
      else @garbage_count += 1
      end
    end

    def parse_group(string, depth = 1)
      strip_garbage
      depth
    end

    def part_one
      @input.each_char do |char|
        @garbage ? parse_garbage(char) : parse(char)
      end

      @total_score
    end

    def part_two
      part_one
      @garbage_count
    end
  end
end
