Given /^an instance of "([^"]*)" with property "([^"]*)" set to "([^"]*)"$/ do |arg1, arg2, arg3| #"
  uri = $sfcb.uri
  cmd = "wbemein #{uri}/test/test:#{arg1}"
  STDERR.puts "Calling #{cmd}"
  out = `#{cmd}`
  STDERR.puts "Enum instance names returned '#{out}'"
  raise unless out =~ Regexp.new(arg1)
  out = `wbemgi http://#{out}`
  STDERR.puts "Get instance returned '#{out}'"
  raise unless out =~ Regexp.new(arg2)
  raise unless out =~ Regexp.new(arg3)
end

Then /^I should see "([^"]*)" in enumerated class names$/ do |arg1| #"
  uri = $sfcb.uri
  out = `wbemecn #{uri}`
  raise unless out =~ Regexp.new(arg1)
end

Then /^I should see "([^"]*)" in namespace "([^"]*)"$/ do |arg1, arg2|
  uri = $sfcb.uri
  out = `wbemecn #{uri}/#{arg2}`
  raise unless out =~ Regexp.new(arg1)
end
  
Then /^I should see "([^"]*)" in enumerated instance names$/ do |arg1| #"
  uri = $sfcb.uri
  cmd = "wbemein #{uri}/test/test:#{arg1}"
  STDERR.puts "Calling #{cmd}"
  out = `#{cmd}`
  raise unless out =~ Regexp.new(arg1)
end

Then /^the instance of "([^"]*)" should have property "([^"]*)" set to "([^"]*)"$/ do |arg1, arg2, arg3| #"
  uri = $sfcb.uri
  out = `wbemein {uri}/test/test:#{arg1}`
  out = `wbemgi http://#{out}`
  raise unless out =~ Regexp.new(arg2)
  raise unless out =~ Regexp.new(arg3)
end

When /^I create an instance of "([^"]*)" with "([^"]*)" set to "([^"]*)"$/ do |arg1, arg2, arg3| #"
  uri = $sfcb.uri
  cmd = "wbemci '#{uri}/test/test:#{arg1}.#{arg2}=\"#{arg3}\"' '#{arg2}=\"#{arg3}\"'"
  $stderr.puts "Calling #{cmd}"
  out = `#{cmd}`
  raise unless $? == 0
end

When /^I change the property "([^"]*)" to "([^"]*)"$/ do |arg1, arg2|
end
