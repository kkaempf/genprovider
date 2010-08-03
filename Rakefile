require 'rubygems'
require 'cucumber/rake/task'

task :default => [:cucumber]

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format pretty tests/features}
end

task :clean do
  system "rm", "-rf", "generated"
  system "rm", "-f", "stdout.out", "stderr.out"
end