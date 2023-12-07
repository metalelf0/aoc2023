#!/usr/bin/env ruby
require 'test/unit'

class Game
  COMBINATIONS = %i[five_of_a_kind four_of_a_kind full_house three_of_a_kind two_pair one_pair high_card].reverse
  CARDS = %w[A K Q T 9 8 7 6 5 4 3 2 J].reverse
  CARDS_WITHOUT_J = %w[A K Q T 9 8 7 6 5 4 3 2].reverse
end

class Hand
  include Comparable
  attr_accessor :cards, :bid

  def initialize(cards:, bid: 0)
    @cards = cards
    @bid = bid
  end

  def power_combination
    return self.combination unless cards.chars.include?("J")
    highest_combination = :one_pair
    jokers_count = cards.chars.count("J")
    possible_joker_values = Game::CARDS_WITHOUT_J.repeated_permutation(jokers_count)
    possible_joker_values.each do |substitutions|
      new_hand_cards = cards
      substitutions.each do |substitute_char|
        new_hand_cards = new_hand_cards.sub("J", substitute_char)
      end
      new_hand_combination = Hand.new(cards: new_hand_cards, bid: bid).combination
      if Game::COMBINATIONS.index(new_hand_combination) > Game::COMBINATIONS.index(highest_combination)
        highest_combination = new_hand_combination
      end
    end
    return highest_combination
  end

  def combination
    return :five_of_a_kind if cards.match?(/(.)\1{4}/)
    return :four_of_a_kind if cards.chars.sort.join.match?(/(.)\1{3}/)

    if cards.chars.sort.join.match?(/(.)\1{2}(.)\2{1}/) || cards.chars.sort.join.match?(/(.)\1{1}(.)\2{2}/)
      return :full_house
    end

    return :three_of_a_kind if cards.chars.sort.join.match?(/(.)\1{2}/)
    return :two_pair if cards.chars.sort.join.match?(/(.)\1{1}.*(.)\2{1}/)
    return :one_pair if cards.chars.sort.join.match?(/(.)\1{1}/)

    :high_card
  end

  def <=>(other) = (sorting_score <=> other.sorting_score)

  def sorting_score
    [
      Game::COMBINATIONS.index(power_combination),
      Game::CARDS.index(cards.chars[0]),
      Game::CARDS.index(cards.chars[1]),
      Game::CARDS.index(cards.chars[2]),
      Game::CARDS.index(cards.chars[3]),
      Game::CARDS.index(cards.chars[4]),
  ]
  end
end

def run_tests
  # --- combination
  raise 'Failed test: :five_of_a_kind' unless :five_of_a_kind == Hand.new(cards: 'AAAAA').combination
  raise 'Failed test: :four_of_a_kind' unless :four_of_a_kind == Hand.new(cards: 'AABAA').combination
  raise 'Failed test: :full_house' unless :full_house == Hand.new(cards: 'AABBB').combination
  raise 'Failed test: :three_of_a_kind' unless :three_of_a_kind == Hand.new(cards: '12BBB').combination
  raise 'Failed test: :two_pair' unless :two_pair == Hand.new(cards: '2323A').combination
  raise 'Failed test: :one_pair' unless :one_pair == Hand.new(cards: '2234A').combination
  raise 'Failed test: :high_card' unless :high_card == Hand.new(cards: '23457').combination

  # --- power_combination
  raise 'Failed test: :power_combination_at_least_one_pair' unless :one_pair == Hand.new(cards: '2345J').power_combination

  # --- Ranking
  raise 'Failed test: first is higher' unless Hand.new(cards: 'AAAAA') > Hand.new(cards: '12345')
  raise 'Failed test: second is higher' unless Hand.new(cards: '23456') < Hand.new(cards: 'AAAAA')
  raise 'Failed test: same cards' unless Hand.new(cards: '62345') == Hand.new(cards: '62345')
  raise 'Failed test: higher first card' unless Hand.new(cards: '82345') > Hand.new(cards: '23456')
  raise 'Failed test: lower first card' unless Hand.new(cards: '23456') < Hand.new(cards: '34567')

  # --- Create with bid
  raise 'Failed test: create with big' unless 123 == Hand.new(cards: '23457', bid: 123).bid
end

run_tests

hands = File.readlines('input.txt')
            .map { |line| line.split(' ') }
            .map { |cards, bid| Hand.new(cards: cards, bid: bid.to_i) }

# puts hands.sort.map { |hand| "#{hand.cards} => #{hand.combination} (#{hand.bid})"}

puts hands.sort.map.with_index { |hand, index| hand.bid * (index + 1) }.sum
