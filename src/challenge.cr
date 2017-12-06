abstract class Challenge
  @input : String

  def initialize(input : IO)
    @input = input.gets_to_end
  end

  abstract def part_one
  abstract def part_one

  def run(part)
    case part
    when 1 then part_one
    when 2 then part_two
    else raise "Invalid part:#{part}"
    end
  end
end
