require 'rake/clean'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format pretty features}
end

CLEAN.include("generated", "*.out", "*.err")
