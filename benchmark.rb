require 'benchmark'

# Alias std lib CSV class
require 'csv'
CSVStdLib = CSV.dup

# Alias our custom parser
require_relative './csv'
CSVCustom = CSV

n = 10000
str = "a,b,c\nd,e,f\n\"g\",\"h\",\"i\""

Benchmark.bm(8) do |x|
  x.report("std lib:") { n.times { CSVStdLib.parse(str) } }
  x.report("custom:")  { n.times { CSVCustom.parse(str) } }
end
