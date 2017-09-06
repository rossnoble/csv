require 'pry'

class CSV
  NEWLINE_CHAR   = "\n"
  QUOTE_CHAR     = '"'
  DELIMITER_CHAR = ","

  def self.parse(*args)
    self.new(args[0], :delimiter => args[1], :quote => args[2]).parse
  end

  attr_reader :input_string, :input_array, :input_size, :delimiter, :quote

  def initialize(input, opts = {})
    @input_string = input.to_s
    @input_array  = input.to_s.split('')
    @input_size   = input_array.size
    @delimiter    = opts[:delimiter] || DELIMITER_CHAR
    @quote        = opts[:quote] || QUOTE_CHAR
  end

  def parse
    # Check for unclosed quotes
    if input_string.count(quote) % 2 != 0
      raise ArgumentError
    end

    result = [[]]
    token = ""
    quote_open = false

    input_array.each_with_index do |value, index|
      if (index + 1 == input_array.size) # EOF
        token += value unless value == quote
        result.last.push(token)
        token = ""
        next
      end

      case value
      when quote
        next_char = input_array[index + 1]
        if next_char == quote
          token += quote
          quote_open = false
        else
          quote_open = !quote_open
        end
      when delimiter
        # Append and reset token
        if quote_open
          token += value
        else
          result.last.push(token)
          token = ""
        end
      when NEWLINE_CHAR
        if quote_open
          token += value
        else
          # Append token and create new row
          result.last.push(token)
          result.push([])
          token = ""
        end
      else
        # Append to token string
        token += value
      end
    end

    result
  end
end
