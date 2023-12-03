#!/usr/bin/env ruby

sum = 0

@conversions = {
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9
}

def numbers_from_string(string)
  start_of_string_regex = /^(\d|one|two|three|four|five|six|seven|eight|nine)/
  end_of_string_regex = /(\d|one|two|three|four|five|six|seven|eight|nine)$/

  hunt_for_start = string
  while (!hunt_for_start.match? start_of_string_regex)
    hunt_for_start = hunt_for_start[1..-1]
  end
  first_char = hunt_for_start.match(start_of_string_regex).to_s

  hunt_for_end = string
  while (!hunt_for_end.match? end_of_string_regex)
    hunt_for_end = hunt_for_end[0..-2]
  end
  last_char = hunt_for_end.match(end_of_string_regex).to_s

  first_number = @conversions[first_char] || first_char.to_i
  last_number = @conversions[last_char] || last_char.to_i

  return first_number, last_number
end

File.readlines("input.txt").each do |line|
  first_digit, last_digit = numbers_from_string(line)
  number = "#{first_digit}#{last_digit}".to_i
  p "#{line} -> (#{number})"
  sum += number
end

p sum
