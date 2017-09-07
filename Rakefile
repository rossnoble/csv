task default: %w[test]

task :test do
  ruby "$(which rspec) *_test.rb"
end

task :bench do
  ruby "benchmark.rb"
end
