require "./days"
require "./days/*"

module Cli
  def self.run(day, part)
    {% begin %}
      case day
      {% for day in 1..25 %}
        when {{day.stringify}}
          {% module_name = "Day#{day < 10 ? "0#{day}".id : day}" %}
          {% if Days.has_constant?(module_name) %}
            puts "Waiting for puzzle input..." 
            Days::{{module_name.id}}.new(STDIN).run(part.to_i)
          {% else %}
            abort("Day {{day}} not yet implemented")
          {% end %}
      {% end %}
      end
    {% end %}
  end
end

abort("Usage: #{PROGRAM_NAME} <day> <part>") unless ARGV.size == 2

day, part = ARGV

puts Cli.run(day, part)
