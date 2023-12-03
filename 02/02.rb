#!/usr/bin/env ruby
require 'debug'

class Draw
  attr_accessor :blue, :green, :red

  def initialize(string)
    @red = string.match(/(\d+) red/)[1].to_i rescue 0
    @green = string.match(/(\d+) green/)[1].to_i rescue 0
    @blue = string.match(/(\d+) blue/)[1].to_i rescue 0
  end

  def possible?(max_red, max_green, max_blue)
    max_red >= red && max_green >= green && max_blue >= blue
  end
end

class Game
  attr_accessor :id, :draws

  def initialize(string)
    @id = string.match(/Game (\d+):.*$/)[1].to_i
    @draws = string.split(":").last.split(";").map do |draw_string|
      Draw.new(draw_string)
    end
  end

  def power
    minimum_reds = draws.map(&:red).max
    minimum_greens = draws.map(&:green).max
    minimum_blues = draws.map(&:blue).max
    return minimum_reds * minimum_blues * minimum_greens
  end
end

games = File.open("input.txt").readlines.map do |line|
  Game.new(line)
end

# part 1 output

valid_games =  games.select do |game|
  game.draws.all? { |draw| draw.possible?(12, 13, 14) }
end

p valid_games.sum(&:id)

# part 2 output

p games.sum(&:power)


