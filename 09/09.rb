#!/usr/bin/env ruby
#
# This solution isn't very elegant as the methods "#compute_all_rows",
# "#compute_all_increments" and "#compute_all_previous_increments" operate on
# the same data, so to get correct results a new Sequence instance has to be
# instantiated every time before calling #next_value or #previous_value. It's
# enough for the sake of the AoC and it performs decently, so... time to get
# outside :)

class Sequence
  attr_accessor :first_row, :rows

  def initialize(first_row:)
    @first_row = first_row.split(' ').map(&:to_i)
    @rows = [@first_row]
  end

  def next_value
    compute_all_rows
    compute_all_increments
    rows.first.last
  end

  def previous_value
    compute_all_rows
    compute_all_previous_increments
    rows.first.first
  end

  private

  def compute_all_rows
    until rows.last.all? { |difference| difference.zero? }
      last_row = rows.last
      new_row = 0.upto(last_row.length - 2).map do |index|
        last_row[index + 1] - last_row[index]
      end
      rows << new_row
    end
  end

  def compute_all_increments
    rows.reverse.each_with_index do |row, index|
      row << if index.zero?
               0
             else
               row.last + rows[-index].last
             end
    end
  end

  def compute_all_previous_increments
    rows.reverse.each_with_index do |row, index|
      previous_value = if index.zero?
                         0
                       else
                         row.first - rows[-index].first
                       end
      row.unshift previous_value
    end
  end
end

class Runner
  def self.result(source:)
    File.readlines(source).map { |first_row| Sequence.new(first_row:).next_value }.sum
  end

  def self.result_part_two(source:)
    File.readlines(source).map { |first_row| Sequence.new(first_row:).previous_value }.sum
  end
end

def test_sequence
  sequence = Sequence.new(first_row: '0 3 6 9 12 15')
  raise 'Cannot build correctly!' unless sequence.first_row == [0, 3, 6, 9, 12, 15]

  sequence.send(:compute_all_rows) # yeah, I know we shouldn't test privates...
  raise 'Cannot compute rows!' unless sequence.rows == [sequence.first_row, [3, 3, 3, 3, 3], [0, 0, 0, 0]]

  sequence.send(:compute_all_increments) # yeah, I know we shouldn't test privates...
  raise 'Cannot compute increments!' unless sequence.rows == [[0, 3, 6, 9, 12, 15, 18], [3, 3, 3, 3, 3, 3],
                                                              [0, 0, 0, 0, 0]]

  sequence = Sequence.new(first_row: '0 3 6 9 12 15')
  raise 'Cannot extract next value!' unless sequence.next_value == 18

  sequence = Sequence.new(first_row: '10 13 16 21 30 45')
  raise 'Cannot extract next value (another sequence)!' unless sequence.next_value == 68
end

def test_sequence_part_two
  sequence = Sequence.new(first_row: '10 13 16 21 30 45')
  sequence.send(:compute_all_rows) # this is the same as before, so no need to test it again
  sequence.send(:compute_all_previous_increments) # yeah, I know we shouldn't test privates...
  raise 'Cannot compute previous increments!' unless sequence.rows == [[5, 10, 13, 16, 21, 30, 45],
                                                                       [5, 3, 3, 5, 9, 15], [-2, 0, 2, 4, 6], [2, 2, 2, 2], [0, 0, 0]]

  sequence = Sequence.new(first_row: '10 13 16 21 30 45')
  raise 'Cannot extract previous value!' unless sequence.previous_value == 5
end

def test_runner
  raise 'Cannot compute increments sum!' unless Runner.result(source: 'small_input.txt') == 114
  raise 'Cannot compute prev values sum!' unless Runner.result_part_two(source: 'small_input.txt') == 2
end

def run_the_tests
  test_sequence
  test_runner
  test_sequence_part_two
end

run_the_tests

p Runner.result(source: 'input.txt')
p Runner.result_part_two(source: 'input.txt')
