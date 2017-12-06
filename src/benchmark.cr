require "./days/*"

macro measure
  started = Time.now
  result = {{ yield }}
  { ((Time.now - started).total_milliseconds * 1000).round.to_i, result }
end

macro bench(day, part)
  {% module_name = "Day#{day < 10 ? "0#{day}".id : day}" %}
  {% if Days.has_constant?(module_name) %}
    input_file = ARGV[{{(day - 1) * 2 + part - 1}}]?
    abort("Input file missing for day {{day}} part {{part}}") unless input_file

    File.open(input_file) do |input|
      time, result = measure do
        Days::{{module_name.id}}.new(input).run({{part}})
      end
      puts "{{day}} {{part}} #{result} #{time}"
    end
  {% end %}
end

{% for day in 1..25 %}
  {% for part in 1..2 %}
    bench({{day}}, {{part}})
  {% end %}
{% end %}
