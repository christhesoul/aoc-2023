module Day01
  class << self
    def part_one(input)
      numberizer = Numberizer.new(check_words: false)
      input.sum { |line| calibration_value(line, numberizer) }
    end

    def part_two(input)
      numberizer = Numberizer.new(check_words: true)
      input.sum { |line| calibration_value(line, numberizer) }
    end

    def calibration_value(line, numberizer)
      numberizer.numberize(line).then do |nums|
        (nums.first + nums.last).to_i
      end
    end
  end

  class Numberizer
    NUM_STRINGS = (1..9).map(&:to_s)
    NUMBER_WORDS = %w[zero one two three four five six seven eight nine]

    def initialize(check_words:)
      @check_words = check_words
    end
    attr_reader :check_words

    def numberize(line)
      line.chars.filter_map.with_index do |char, index|
        next char if NUM_STRINGS.include?(char)

        number_word_at_index(line, index)&.to_s if check_words
      end.compact
    end

    def number_word_at_index(line, index)
      NUMBER_WORDS.find_index { |word| line[index, word.length] == word }
    end
  end
end

input = File.read("inputs/01.txt").split
puts Day01.part_one(input)
puts Day01.part_two(input)
