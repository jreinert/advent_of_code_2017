require "benchmark"

PUZZLE_INPUT = File.read(ARGV[0])

def part_one(input)
  sequence = input.each_char.cycle.first(input.size + 1)

  sequence.cons(2, reuse: true).sum do |(a, b)|
    a == b ? a.to_i : 0
  end
end

def part_two(input)
  steps = input.size / 2
  sequence = input.each_char.cycle.first(input.size + steps).to_a

  input.size.times.sum do |i|
    a, b = sequence.values_at(i, i + steps)
    a == b ? a.to_i : 0
  end
end

def part_two_zip(input)
  first_half = input.each_char
  second_half = input.each_char.cycle.skip(input.size / 2).first(input.size)
  sequence = first_half.zip(second_half)

  sequence.sum do |(a, b)|
    a == b ? a.to_i : 0
  end
end

results = StaticArray(Int32, 3).new(0)

Benchmark.ips do |x|
  x.report("part one:") do
    results[0] = part_one(PUZZLE_INPUT)
  end

  x.report("part two:") do
    results[1] = part_two(PUZZLE_INPUT)
  end

  x.report("part two zip:") do
    results[2] = part_two_zip(PUZZLE_INPUT)
  end
end

puts results.join("\n")
