require 'rake/clean'
begin
require 'cucumber/rake/task'

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format pretty features}
end
rescue Exception => e
  STDERR.puts "Cucumber not found, skipping feature tests"
end

CLEAN.include("generated", "*.out", "*.err")
