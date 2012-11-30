require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs = ["."]
  t.warning = true
  t.verbose = true
  t.test_files = FileList['test/test_*.rb']
end

task :test => [:registration]
