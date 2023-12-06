#!/usr/bin/env ruby

def winning_times(duration:, target_distance:)
  0.upto(duration).map do |loading_time|
    (duration - loading_time) * loading_time
  end.select { |distance| distance > target_distance }
end

def parse_input(file:)
  lines = File.readlines(file)
  times = lines.shift.split(":").last.split(" ").map(&:to_i)
  distances = lines.shift.split(":").last.split(" ").map(&:to_i)
  [times, distances].transpose.map { |duration, target_distance| {duration: , target_distance:  } }
end

def parse_input_part_2(file:)
  lines = File.readlines(file)
  duration = lines.shift.split(":").last.split(" ").join.to_i
  target_distance = lines.shift.split(":").last.split(" ").join.to_i
  [ {duration: , target_distance:  } ]
end

winning_combinations_size = parse_input_part_2(file: "input.txt").map do |race|
  winning_times(duration: race[:duration], target_distance: race[:target_distance]).size
end

puts winning_combinations_size.inject(1) { |result, winning_combinations_size| result = result * winning_combinations_size }
