# Write a CSV parser that handles complex files without using the standard library.
# A standard CSV has fields separated by commas and rows separated by newlines. It may
# also have fields wrapped in quotes. Your CSV parser needs to handle quoted fields that
# may contain delimiter and newline characters.

# Spec (based on https://tools.ietf.org/html/rfc4180):
# - The parser should return an array of arrays, one array for each row of the CSV file.
# - Rows are delimited by the newline character ("\n").
# - Each column is divided by a separator character (default ",").
# - Empty fields are valid.
# - Likewise, an empty row is still valid, and effectively contains a single empty field.
# - Uneven rows are valid.
# - A quoted field starts and ends with the same character (default '"'), and every
# character in between makes up the field value, including delimiters and newlines.
# - Quoted fields start immediately following a separator character, newline,
# or start of the file.
# - A quote character within a quoted field must be escaped by preceding it
# with another quote character.
# - Throw an error on unclosed quoted fields (or stray quotes inside fields).

# Bonus points:
# - Write tests that test your parser against the above spec.
# - Benchmark your solution.

class CSV
  def self.parse(*); end
end

# Examples:

# Expected: [['a', 'b', 'c'], ['d', 'e', 'f']]
print CSV.parse("a,b,c\nd,e,f"), "\n"

# Expected: [["one", "two wraps,\nonto \"two\" lines", "three"], ["4", "", "6"]]
print CSV.parse("one,\"two wraps,\nonto \"\"two\"\" lines\",three\n4,,6"), "\n"

# Expected: [['alternate', '"quote"'], [''], ['character', 'hint: |']]
print CSV.parse("|alternate|\t|\"quote\"|\n\n|character|\t|hint: |||", "\t", "|"), "\n"

# Expected: "Argument error: unclosed quote"
begin
  print CSV.parse('"dog","cat","uhoh'), "\n"
rescue ArgumentError => e
  puts "ArgumentError: #{e}"
end
