#!/usr/bin/env ruby

class Matrix
  attr_accessor :data

  def initialize(source_file:)
    @data = File.readlines(source_file).map(&:strip).map(&:chars)
  end

  def value_at(row, col)
    # This is to prevent negative indexes from fetching data from the end of the array
    return nil if row.negative? || col.negative?

    begin
      @data.fetch(row).fetch(col)
    rescue StandardError
      nil
    end
  end

  def surrounding(row, col)
    [
      value_at(row - 1, col - 1),
      value_at(row - 1, col),
      value_at(row - 1, col + 1),
      value_at(row, col - 1),
      value_at(row, col + 1),
      value_at(row + 1, col - 1),
      value_at(row + 1, col),
      value_at(row + 1, col + 1)
    ].reject(&:nil?)
  end

  def targets
    valid_numbers = []

    @data.each_with_index do |row, row_index|
      row_text = row.join
      # take all numbers (sequences of digits) from current row
      row_text.to_enum(:scan, /\d+/).map { Regexp.last_match }.each do |match_data|
        number_value = match_data.to_s.to_i
        start_offset, end_offset = match_data.offset(0)

        surroundings_of_all_digits = []
        start_offset.upto(end_offset - 1) do |col|
          surroundings_of_all_digits << surrounding(row_index, col)
        end

        if surroundings_of_all_digits
           .flatten
           .all? { |n| n.match?(/\d/) || (n == '.') }
          p "REJECTING #{number_value} because #{surroundings_of_all_digits.flatten.join}"
        else
          p "INCLUDING #{number_value} because #{surroundings_of_all_digits.flatten.join}"
          valid_numbers << number_value
        end
      end
    end

    valid_numbers
  end
end

matrix = Matrix.new source_file: 'input.txt'

# raise "Unexpected!" unless '4' == matrix.value_at(0, 0)
# raise "Unexpected!" unless nil == matrix.value_at(1000, 1000)
# raise "Unexpected!" unless ["6", ".", "."] == matrix.surrounding(0, 0)
# raise "Unexpected!" unless 467 == matrix.targets.first
# raise "Unexpected!" if matrix.targets.include?(114)

p matrix.targets.sum
