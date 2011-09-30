Given /^an instance of "([^"]*)" with property "([^"]*)" set to "([^"]*)"$/ do |arg1, arg2, arg3| #"
  url = $sfcb.url
  cmd = "wbemein #{url}/test/test:#{arg1}"
  STDERR.puts "Calling #{cmd}"
  out = `#{cmd}`
  STDERR.puts "Enum instance names returned '#{out}'"
  raise unless out =~ Regexp.new(arg1)
  @instance = out.chomp
  out = `wbemgi http://#{out}`
  STDERR.puts "Get instance returned '#{out}'"
  raise unless out.include? "#{arg2}=\"#{arg3}\""
end

Then /^I should see "([^"]*)" in enumerated class names$/ do |arg1| #"
  url = $sfcb.url
  out = `wbemecn #{url}`
  raise unless out =~ Regexp.new(arg1)
end

Then /^I should see "([^"]*)" in namespace "([^"]*)"$/ do |arg1, arg2|
  url = $sfcb.url
  out = `wbemecn #{url}/#{arg2}`
  raise unless out =~ Regexp.new(arg1)
end
  
Then /^I should see "([^"]*)" in enumerated instance names$/ do |arg1| #"
  url = $sfcb.url
  cmd = "wbemein #{url}/test/test:#{arg1}"
  STDERR.puts "Calling #{cmd}"
  out = `#{cmd}`
  raise unless out =~ Regexp.new(arg1)
end

Then /^the instance of "([^"]*)" should have property "([^"]*)" set to "([^"]*)"$/ do |arg1, arg2, arg3| #"
  url = $sfcb.url
  cmd = "wbemein #{url}/test/test:#{arg1}"
  STDERR.puts "Calling #{cmd}"
  out = `#{cmd}`
  STDERR.puts "-> '#{out}'"
  out = `wbemgi http://#{out}`
  STDERR.puts "-> '#{out}'"
  raise unless out.include? "#{arg2}=\"#{arg3}\""
end

When /^I create an instance of "([^"]*)" with "([^"]*)" set to "([^"]*)"$/ do |arg1, arg2, arg3| #"
  url = $sfcb.url
  cmd = "wbemci '#{url}/test/test:#{arg1}.#{arg2}=\"#{arg3}\"' '#{arg2}=\"#{arg3}\"'"
  $stderr.puts "Calling #{cmd}"
  out = `#{cmd}`
  raise unless $? == 0
end

When /^I change the property "([^"]*)" to "([^"]*)"$/ do |arg1, arg2|
  cmd = "wbemmi http://#{@instance} #{arg1}=\"#{arg2}\""
  $stderr.puts "Calling #{cmd}"
  out = `#{cmd}`
  STDERR.puts "Modify instance returned '#{out}'"
end
