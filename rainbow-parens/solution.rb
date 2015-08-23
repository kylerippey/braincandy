require 'colorize'

class LispFormatter
  attr_reader :input

  TOKENS = {
    '(' => ')',
    '[' => ']',
    '{' => '}',
  }

  COLORS = [
    :red,
    :yellow,
    :green,
    :blue,
    :magenta,
  ]

  def initialize(input)
    @input = input
  end

  def format
    stack = []
    output = ""
    in_quotes = false

    input.each_char do |token|
      in_quotes = !in_quotes if token == "\""

      unless in_quotes
        case token
        when *opening_tokens
          color = color_for_depth(stack.length)
          stack.push(token)

          token = token.colorize(color)
        when *closing_tokens
          opening_token = stack.pop
          raise "Unexpected token: '#{token}'" if opening_token.nil? || !matching_pair?(opening_token, token)

          color = color_for_depth(stack.length)
          token = token.colorize(color)
        end
      end

      output << token
    end

    raise "Missing closing token for '#{stack.pop}'" unless stack.empty?

    output
  end

  private

  def color_for_depth(depth)
    COLORS.rotate(depth).first
  end

  def opening_tokens
    TOKENS.keys
  end

  def closing_tokens
    TOKENS.values
  end

  def matching_pair?(opening, closing)
    TOKENS[opening] == closing
  end
end

puts LispFormatter.new("(define square (lambda (x) (* x x)))").format
puts LispFormatter.new("([{()()}])").format
puts LispFormatter.new("(define (lambda (x) (add5 (+ 5 x))))").format
puts LispFormatter.new("(define smile \"(:\")").format
puts LispFormatter.new("(define smile \"(:\"; define frown \"):\")").format
