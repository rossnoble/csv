require './csv'

RSpec.describe CSV, "#parse" do
  context "with nil input" do
    it "should return an empty array" do
      expect(CSV.parse(nil)).to eq([[]])
    end
  end

  context "for unclosed quote" do
    it "raises an argument error" do
      expect{CSV.parse('"dog","cat","uhoh')}.to raise_error(ArgumentError)
    end
  end

  context "for a valid string without quotes" do 
    it "returns an array of arrays" do
      parsed = CSV.parse("a,b,c\nd,e,f")
      expect(parsed).to eq([['a', 'b', 'c'], ['d', 'e', 'f']])
    end
  end

  context "for a non-default delimiter" do 
    it "returns an array of arrays" do
      parsed = CSV.parse("a$b$c\nd$e$f", "$")
      expect(parsed).to eq([['a', 'b', 'c'], ['d', 'e', 'f']])
    end
  end

  context "for quoted cells" do 
    it "returns an array of arrays" do
      parsed = CSV.parse(%{"a","b",c\n"d",e,"f"})
      expect(parsed).to eq([['a', 'b', 'c'], ['d', 'e', 'f']])
    end
  end

  context "for cells with nested separator characters" do 
    skip "returns the correct cell values" do
      #parsed = CSV.parse("one,\"two wraps,\nonto \"\"two\"\" lines\",three\n4,,6")
      parsed = CSV.parse('one,"two wraps,\nonto ""two"" lines",three\n4,,6')
      expect(parsed).to eq([["one", "two wraps,\nonto \"two\" lines", "three"], ["4", "", "6"]])
    end
  end

  context "for alternate quote and separator characters" do 
    skip "returns an array of array" do
      parsed = CSV.parse("|alternate|\t|\"quote\"|\n\n|character|\t|hint: |||", "\t", "|")
      expect(parsed).to eq([['alternate', '"quote"'], [''], ['character', 'hint: |']])
    end
  end
end
