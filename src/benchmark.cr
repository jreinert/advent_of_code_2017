require "benchmark"
require "./days/*"

macro measure
  result = nil
  execution_time = Benchmark.measure { result = {{ yield }} }
  { (execution_time.real * 10**6).round.to_i, result }
end

macro bench(day, part)
  {% module_name = "Day#{day < 10 ? "0#{day}".id : day}" %}
  {% if Days.has_constant?(module_name) %}
    input_file = ARGV[{{(day - 1) * 2 + part - 1}}]?
    abort("Input file missing for day {{day}} part {{part}}") unless input_file

    input = File.read(input_file)
    time, result = measure do
      Days::{{module_name.id}}.new(input).run({{part}})
    end
    puts "{{day}} {{part}} #{result} #{time}"
  {% end %}
end

{% for day in 1..25 %}
  {% for part in 1..2 %}
    bench({{day}}, {{part}})
  {% end %}
{% end %}
