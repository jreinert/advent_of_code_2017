require "./days"
require "./days/*"
require "ecr"

module Cli
  USAGE =<<-USAGE
    Usage: #{PROGRAM_NAME} <action> <day> [<part>]\n
      Actions:\n
      run : run <day> <part> and print result\n
      gen : generate <day> source
    USAGE


  def self.run(day, part)
    {% begin %}
      case day
      {% for day in 1..25 %}
        when {{day.stringify}}
          {% module_name = "Day#{day < 10 ? "0#{day}".id : day}" %}
          {% if Days.has_constant?(module_name) %}
            puts "Waiting for puzzle input..." 
            Days::{{module_name.id}}.new(STDIN.gets_to_end).run(part.to_i)
          {% else %}
            abort("Day {{day}} not yet implemented")
          {% end %}
      {% end %}
      end
    {% end %}
  end

  def self.generate(day)
    file_path = File.expand_path("../days/day_#{day.rjust(2, '0')}.cr", __FILE__)

    File.open(file_path, "w+") do |f|
      ECR.embed("day_template.ecr", f)
    end
  end
end

abort(Cli::USAGE) if ARGV.size < 2
action, day = { ARGV.shift, ARGV.shift }

case action
when "run"
  part = ARGV.shift?
  abort(Cli::USAGE) unless part
  puts Cli.run(day, part)
when "gen" then Cli.generate(day)
else abort(Cli::USAGE)
end
