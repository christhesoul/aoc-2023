require "pry"

module Day02
  LIMITS = {
    red: 12,
    green: 13,
    blue: 14
  }.freeze

  class << self
    def part_one(input)
      input.filter_map do |line|
        Game.new(line).then { |game| game.id if game.valid? }
      end.sum
    end

    def part_two(input)
      input.filter_map do |line|
        Game.new(line).then { |game| game.to_max_h.values.inject(&:*) }
      end.sum
    end
  end

  class Game
    def initialize(line)
      @name, @raw_hands = line.split(":")
    end
    attr_reader :name, :raw_hands

    def id
      name.delete("^0-9").to_i
    end

    def hands
      raw_hands.split(";").map { |raw_hand| Hand.new(raw_hand) }
    end

    def valid?
      hands.all?(&:valid?)
    end

    def to_max_h
      hands.each_with_object({ red: 0, blue: 0, green: 0 }) do |hand, max|
        hand.cubes.each do |color, value|
          max[color] = value if value > max[color]
        end
      end
    end
  end

  class Hand
    def initialize(raw_hand)
      @raw_hand = raw_hand
      @cubes = to_h
    end
    attr_reader :raw_hand
    attr_reader :cubes

    def to_h
      raw_hand.split(",").each_with_object({}) do |raw_cube_count, cubes|
        count, colour = raw_cube_count.strip.split(" ")
        cubes[colour.to_sym] = count.to_i
      end
    end

    def valid?
      LIMITS.all? do |color, value|
        next true if cubes[color].nil?

        cubes[color] <= value
      end
    end
  end
end
