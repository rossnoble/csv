class CSV
  NEWLINE_CHAR   = "\n"
  QUOTE_CHAR     = '"'
  DELIMITER_CHAR = ","

  def self.parse(*args)
    self.new(args[0], :delimiter => args[1], :quote => args[2]).parse
  end

  attr_reader :input_string, :input_array, :delimiter, :quote

  def initialize(input, opts = {})
    @input_string = input.to_s
    @input_array  = input.to_s.split('')
    @delimiter    = opts[:delimiter] || DELIMITER_CHAR
    @quote        = opts[:quote]     || QUOTE_CHAR
  end

  def parse
    # Check for unclosed quotes
    raise ArgumentError if input_string.count(quote) % 2 != 0

    result     = []
    token      = ""
    quote_open = false

    input_array.each_with_index do |value, index|
      # Create first row
      result.push([]) if index == 0

      # Handle end of input string
      if (index + 1 == input_array.size)
        token += value unless value == quote

        result.last.push(token)
        return result
      end

      case value
      when quote
        # Look ahead at next char to see if escaped
        next_char = input_array[index + 1]
        prev_char = input_array[index - 1]
        if next_char == quote && prev_char != quote
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
        token += value
      end
    end

    result
  end
end
