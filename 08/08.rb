#!/usr/bin/env ruby

class Exploration
  attr_accessor :directions, :elements

  def initialize(source:)
    lines = File.readlines(source)
    @directions = parse_directions(lines.shift.strip)
    @elements = parse_elements(lines.map(&:strip))
  end

  def steps
    node = 'AAA'
    step = 0
    while node != 'ZZZ'
      next_step = directions[step % directions.size]
      path = (next_step == 'L' ? :left : :right)
      node = elements[node][path]
      step += 1
    end
    step
  end

  def steps_part_2
    starting_nodes = elements.keys.select { |key| key.end_with?('A') }
    loops = starting_nodes.map do |node|
      step = 0
      until node.end_with?('Z')
        next_step = directions[step % directions.size]
        path = (next_step == 'L' ? :left : :right)
        node = elements[node][path]
        step += 1
      end
      step
    end

    loops.reduce(1) { |lcm, num| lcm.lcm(num) }
  end

  private

  def parse_directions(line)
    line.chars
  end

  def parse_elements(lines)
    lines.reject { |line| line == '' }.each_with_object({}) do |line, elements|
      matches = line.match(/(\w+) = \((\w+), (\w+)\)/)
      key = matches[1]
      left = matches[2]
      right = matches[3]

      elements[key] = { left:, right: }
    end
  end
end

def run_tests
  exploration = Exploration.new(source: 'small_input.txt')
  raise 'Cannot parse directions!' unless exploration.directions == %w[R L]
  raise 'Wrong number of elements!' unless exploration.elements.size == 7
  raise 'Cannot parse element key!' unless exploration.elements.keys.include?('AAA')
  raise 'Cannot parse element directions (L)!' unless exploration.elements['AAA'][:left] == 'BBB'
  raise 'Cannot parse element directions (R)!' unless exploration.elements['AAA'][:right] == 'CCC'
  raise 'Cannot calculate exploration steps!' unless exploration.steps == 2

  exploration = Exploration.new(source: 'small_input_2.txt')
  raise 'Cannot calculate exploration steps!' unless exploration.steps == 6
end

def run_tests_part_2
  exploration = Exploration.new(source: 'small_input_part_2.txt')
  raise 'Cannot calculate exploration steps for part 2!' unless exploration.steps_part_2 == 6
end

run_tests
run_tests_part_2

exploration = Exploration.new(source: 'input.txt')
puts exploration.steps
puts exploration.steps_part_2
