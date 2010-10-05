Given /^nothing$/ do
  # no-op
end

Given /^I have a mof file called "([^"]*)"$/ do |arg1|
  File.exists?("mof/#{arg1}")
end

Given /^I have a registration "([^"]*)"$/ do |arg1| #"
  @registration = arg1
end

Given /^an instance of "([^"]*)" with property "([^"]*)" set to "([^"]*)"$/ do |arg1, arg2, arg3| #"
  $stderr.puts "Calling wbemein http://localhost:5988/test/test:#{arg1}"
  out = `wbemein http://localhost:5988/test/test:#{arg1}`
  $stderr.puts "Enum instance names returned '#{out}'"
  raise unless out =~ Regexp.new(arg1)
  out = `wbemgi http://#{out}`
  $stderr.puts "Get instance returned '#{out}'"
  raise unless out =~ Regexp.new(arg2)
  raise unless out =~ Regexp.new(arg3)
end