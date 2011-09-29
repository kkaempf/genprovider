require 'rake/clean'
require 'cucumber/rake/task'

task :default => [:cucumber]

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format pretty features}
end

CLEAN.include("generated", "stdout.out", "stderr.out")
