#!/usr/bin/env ruby

require_relative 'src/map'
require_relative 'src/tile'
require 'debug'

@game = Map.new(source_file: 'small_messy_input_part_2.txt')
data = @game.data

# First batch: replace dots on the border with `A`
data[0] = data[0].map { |c| c == '.' ? 'A' : c }
last_row = data.length - 1
data[last_row] = data[last_row].map { |c| c == '.' ? 'A' : c }

# for convenience, to do the same with cols, I transpose data and then transpose it back
data = data.transpose
data[0] = data[0].map { |c| c == '.' ? 'A' : c }
last_col = data.length - 1
data[last_col] = data[last_col].map { |c| c == '.' ? 'A' : c }
data = data.transpose

@game.data = data

# Second batch: now I start replacing all dots connected to an "A" with an A, until there are no more dots left
replacements = :whatever
until replacements == 0
  replacements = 0
  0.upto(@game.data.size - 1) do |row|
    0.upto(@game.data.first.size - 1) do |col|
      next unless @game.value_at(row - 1, col)&.char == 'A' ||
                  @game.value_at(row + 1, col)&.char == 'A' ||
                  @game.value_at(row, col - 1)&.char == 'A' ||
                  @game.value_at(row, col + 1)&.char == 'A'

      if @game.data[row][col] != 'A' && @game.data[row][col] == '.'
        @game.data[row][col] = 'A'
        replacements += 1
      end
    end
  end
  p "Replacements are #{replacements}..."
end

@game.data.each do |row|
  p row.join
end

p(@game.data.flatten.flatten.count { |c| c == '.' })
