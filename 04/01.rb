#!/usr/bin/env ruby

# part 1
puts File
  .readlines('input.txt')
  .map { |line| line.split(':').last.strip }
  .map { |line| line.split("|") }
  .map { |p1, p2| [p1.split(" "), p2.split(" ")] }
  .map { |p1, p2| (p2 & p1).size }
  .map { |n| n.zero? ? 0 : 2 ** (n - 1)  }
  .sum

# part 2
lines = File.readlines("input.txt")
copies_count = Array.new(lines.size, 1)

File
  .readlines('input.txt')
  .map { |line| line.split(':').last.strip }
  .map { |line| line.split("|") }
  .map { |p1, p2| [p1.split(" "), p2.split(" ")] }
  .map { |p1, p2| (p2 & p1).size }.each_with_index do |current_score, current_line|
    (current_line + 1).upto(current_line + current_score) do |index|
      copies_count[index] += copies_count[current_line]
    end
  end

p copies_count.sum
