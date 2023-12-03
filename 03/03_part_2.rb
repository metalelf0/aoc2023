#!/usr/bin/env ruby

class Matrix
  attr_accessor :data

  def initialize(source_file:)
    @data = File.readlines(source_file).map(&:strip).map(&:chars)
  end

  def value_at(row, col)
    return nil if row.negative? || col.negative?

    begin
      @data.fetch(row).fetch(col)
    rescue StandardError
      nil
    end
  end

  # This assumes there's AT MOST one asterisk in the surroundings of each number.
  def coords_of_surrounding(row, col, char)
    return row - 1, col - 1 if value_at(row - 1, col - 1) == char
    return row - 1, col if value_at(row - 1, col) == char
    return row - 1, col + 1 if value_at(row - 1, col + 1) == char
    return row, col - 1 if value_at(row, col - 1) == char
    return row, col + 1 if value_at(row, col + 1) == char
    return row + 1, col - 1 if value_at(row + 1, col - 1) == char
    return row + 1, col if value_at(row + 1, col) == char
    return row + 1, col + 1 if value_at(row + 1, col + 1) == char

    nil
  end

  def targets
    possible_cogs = []

    @data.each_with_index do |row, row_index|
      row_text = row.join
      row_text.to_enum(:scan, /\d+/).map { Regexp.last_match }.each do |match_data|
        number_value = match_data.to_s.to_i
        start_offset, end_offset = match_data.offset(0)
        start_offset.upto(end_offset - 1) do |col|
          asterisk_row, asterisk_col = coords_of_surrounding(row_index, col, '*')
          possible_cogs << [number_value, asterisk_row, asterisk_col] if asterisk_row || asterisk_col
        end
      end
    end

    possible_cogs.uniq!
  end
end

matrix = Matrix.new source_file: 'input_part_2.txt'

p matrix
  .targets
  .group_by { |target| [target[1], target[2]] }
  .reject { |_key, val| val.size < 2 }
  .values
  .map { |value_and_coords| value_and_coords[0].first * value_and_coords[1].first }
  .sum
# p matrix
