class ScrabbleCheater
  DICTIONARY_PATH = '/usr/share/dict/words'

  attr_reader :tiles

  def initialize(tiles)
    @tiles = tiles.map(&:downcase)
  end

  def suggestions
    @suggestions ||= dictionary.select do |word|
      chars = word.chars

      # Skip any words that contain characters for
      # which we don't have tiles.
      next if chars.any? {|char| !tiles.include?(char)}

      # Only select words that don't require more of
      # a given tile than we have.
      hashify(chars).none? {|k, v| v > tile_hash[k]}
    end
  end

  private

  def tile_hash
    @tile_hash ||= hashify(tiles)
  end

  def hashify(chars)
    h = Hash.new { 0 }
    chars.each {|char| h[char] += 1}
    h
  end

  def dictionary
    @dictionary ||= File.readlines(DICTIONARY_PATH).map(&:chomp).map(&:downcase).select {|word| word.length <= tiles.length}.uniq
  end
end

cheater = ScrabbleCheater.new(["c", "h", "e", "a", "t", "e", "r"])

puts cheater.suggestions
puts "Found #{cheater.suggestions.length} possible words"