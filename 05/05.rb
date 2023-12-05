#!/usr/bin/env ruby
class Array
  def split(value = nil, &block)
    arr = dup
    result = []
    if block_given?
      while (idx = arr.index(&block))
        result << arr.shift(idx)
        arr.shift
      end
    else
      while (idx = arr.index(value))
        result << arr.shift(idx)
        arr.shift
      end
    end
    result << arr
  end

  def in_groups_of(number, fill_with = nil)
    if number.to_i <= 0
      raise ArgumentError,
        "Group size must be a positive integer, was #{number.inspect}"
    end

    if fill_with == false
      collection = self
    else
      # size % number gives how many extra we have;
      # subtracting from number gives how many to add;
      # modulo number ensures we don't add group of just fill.
      padding = (number - size % number) % number
      collection = dup.concat(Array.new(padding, fill_with))
    end

    if block_given?
      collection.each_slice(number) { |slice| yield(slice) }
    else
      collection.each_slice(number).to_a
    end
  end
end

def seeds_from_file(source_file:)
  input = File.readlines(source_file).map(&:strip)
  input.split('').first.first.split(":").last.split(" ").map(&:to_i)
end

def seeds_from_file_part2(source_file:)
  seeds = []
  input = File.readlines(source_file).map(&:strip)
  input.split('').first.first.split(":").last.split(" ").map(&:to_i).in_groups_of(2).each do |start, range_length|
    seeds << { start: start, range_length: range_length }
  end
  seeds
end

# input: an array of lines defining ranges
# e.g.:
# temperature-to-humidity map:
# 0 69 1
# 1 0 69
def build_ranges(lines:)
  lines[1..-1].map do |line|
    destination_range_start, source_range_start, range_length = line.split(" ").map(&:to_i)
    {
      to: [destination_range_start, destination_range_start + range_length],
      from: [source_range_start, source_range_start + range_length]
    }
  end
end

def conversions_from_file(source_file:)
  input = File.readlines(source_file).map(&:strip).split("")
  input.shift

  input.map do |lines|
    build_ranges(lines: )
  end
end

def find_target(number:, conversion_ranges: {})
  return source_number if conversion_ranges.empty?
  conversion_ranges.each do |conversion_range|
    if conversion_range[:from][0] <= number && number <= conversion_range[:from][1]
      index = number - conversion_range[:from][0]
      return conversion_range[:to][0] + index
    end
  end
  return number
end

source_file = "input.txt"
# seeds = seeds_from_file(source_file:)

seeds = seeds_from_file_part2(source_file:)
p seeds.size

conversions = conversions_from_file(source_file:)

lowest = 1/0.0 # Infinity

seeds.each do |seed_range|
  seed_range[:start].upto(seed_range[:start] + seed_range[:range_length]) do |number|
    conversions.each do |conversion_ranges|
      number = find_target(number:, conversion_ranges:)
    end
    if number < lowest
      lowest = number
      puts "New lowest is #{lowest}"
    end
  end
end

puts lowest
