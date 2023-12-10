require 'debug'

class Tile
  attr_accessor :row, :col, :char, :game

  N = [-1, 0].freeze
  S = [1, 0].freeze
  W = [0, -1].freeze
  E = [0, 1].freeze

  TILESET = {
    'S' => [N, S, W, E],
    'F' => [S, E],
    'L' => [N, E],
    '7' => [W, S],
    'J' => [N, W],
    '|' => [N, S],
    '-' => [W, E],
    '.' => []
  }.freeze

  def initialize(row, col, char, game)
    @row = row
    @col = col
    @char = char
    @game = game
  end

  def connects_to?(other_tile)
    target_locations.include?([other_tile.row, other_tile.col]) && other_tile.target_locations.include?([row, col])
  end

  def target_locations
    TILESET[char].map { |direction| [row + direction.first, col + direction.last] }
  end

  def surroundings
    target_locations.map { |location| game.value_at(location.first, location.last) }.compact
  end

  def next_tile(previous_tile:)
    next_tile = surroundings.reject { |tile| tile == previous_tile }.detect { |tile| tile.connects_to?(self) }
  end

  def self.null
    new(-1, -1, 'Z', nil)
  end

  def ==(other)
    !other.nil? && row == other.row && col == other.col && char == other.char
  end
end
