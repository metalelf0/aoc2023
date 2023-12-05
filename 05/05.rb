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
end

def seeds_from_file(source_file:)
  input = File.readlines(source_file).map(&:strip)
  input.split('').first.first.split(":").last.split(" ").map(&:to_i)
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
      to: Range.new(destination_range_start, destination_range_start + range_length),
      from: Range.new(source_range_start, source_range_start + range_length)
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
    if conversion_range[:from].include? number
      index = conversion_range[:from].to_a.index(number)
      return conversion_range[:to].to_a.at(index)
    end
  end
  return number
end

source_file = "input.txt"
seeds = seeds_from_file(source_file:)

conversions = conversions_from_file(source_file:)

conversions.each do |conversion_ranges|
  new_numbers = seeds.map do |number|
    find_target(number:, conversion_ranges:)
  end
  seeds = new_numbers
  print "."
end

p seeds
