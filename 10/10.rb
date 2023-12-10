#!/usr/bin/env ruby

require_relative 'src/map'
require_relative 'src/tile'

def run_the_tests
  map = Map.new(source_file: 'small_input.txt')
  raise 'Cannot parse map correctly!' unless map.data.size == 5
  raise 'Cannot get starting location correctly!' unless map.starting_location.is_a?(Tile)

  location_one = map.starting_location
  location_two = map.value_at(1, 2)
  raise 'Connection one not identified' unless location_one.connects_to?(location_two)

  location_three = map.value_at(1, 3)
  raise 'Connection two not identified' unless location_two.connects_to?(location_three)
end

run_the_tests

def explore(start_location)
  previous_tile = Tile.null
  next_tile = Tile.null
  current_tile = start_location
  navigation_depth = 1
  while next_tile.char != 'S'
    next_tile = current_tile.next_tile(previous_tile:)
    previous_tile = current_tile
    current_tile = next_tile
    navigation_depth += 1
  end
  puts navigation_depth / 2
end

explore Map.new(source_file: 'input.txt').starting_location
