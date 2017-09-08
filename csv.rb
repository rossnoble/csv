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

    result       = []
    token        = ""
    index        = 0
    quote_open   = false
    input_length = input_array.length

    while index < input_length
      value = input_array[index]

      # Create first row
      result.push([]) if index == 0

      # Handle end of input string
      if (index + 1 == input_length)
        token += value unless value == quote

        result.last.push(token)
        return result
      end

      case value
      when quote
        if quote_open
          # Look ahead at next char to see if escaped
          next_char = input_array[index + 1]
          if next_char && next_char == quote
            # Append single quote
            token += value

            # Skip next character
            index += 1
          else
            quote_open = false
          end
        else
          quote_open = !quote_open
        end

      when delimiter
        if quote_open
          token += value
        else
          # Append and reset token
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

      index += 1
    end

    result
  end
end
