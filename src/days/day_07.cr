require "../challenge"

module Days
  class Day07 < Challenge
    class Program
      MATCHER = /^(?<name>\w+) \((?<weight>\d+)\)(?: -> (?<disc>.+))?$/
      @@programs = {} of String => Program

      getter :name

      macro cached(attribute, type)
        @%attribute : {{type.id}}?
        def {{attribute.id}}
          @%attribute ||= {{yield}}
        end
      end

      def initialize(@name : String, @weight : Int32, @disc = [] of String)
      end

      def on_top?
        @disc.empty?
      end

      def carries?(name)
        @disc.includes?(name)
      end

      cached :carrier, Program do
        @@programs.values.find { |program| program.carries?(name) }
      end

      cached :disc, Array(Program) do
        @disc.map { |name| Program.find_by_name(name) }
      end

      cached :weight, Int32 do
        @weight + disc.sum(&.weight)
      end

      cached :cause_for_imbalance, Program do
        weights = disc.map { |program| { program, program.weight } }
        program, weight = weights.find({ nil, nil }) do |program, weight|
          weights.count { |_, w| w == weight } == 1
        end

        program
      end

      def unbalanced?
        cause_for_imbalance
      end

      def self.parse(string)
        match = string.match(MATCHER)
        raise "Line doesn't match" unless match
        disc = match["disc"]?.try { |list| list.split(", ") } || [] of String
        new(match["name"], match["weight"].to_i, disc)
      end

      def self.parse_all(input)
        input.each_line do |line|
          program = parse(line)
          @@programs[program.name] = program
        end
      end

      def self.each
        @@programs.values.each
      end

      def self.find_by_name(name)
        @@programs[name]
      end
    end

    def part_one
      Program.parse_all(@input)
      result = Program.each.find(&.on_top?)
      return unless result

      loop do
        carrier = result.carrier
        break unless carrier
        result = carrier
      end

      result.try(&.name)
    end

    def part_two
      Program.parse_all(@input)
      program = Program.each.find(&.unbalanced?).not_nil!

      loop do
        cause = program.cause_for_imbalance

        if cause
          program = cause
          next
        end

        carrier = program.carrier.not_nil!
        target_weight = carrier.disc.map(&.weight).find do |weight|
          weight != program.weight
        end

        return target_weight.not_nil! - program.disc.sum(&.weight)
      end
    end
  end
end
