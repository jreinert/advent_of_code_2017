PUZZLE_INPUT = STDIN.gets_to_end

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

puts case ARGV[0]
when "1" then part_one(PUZZLE_INPUT)
when "2" then part_two(PUZZLE_INPUT)
end
