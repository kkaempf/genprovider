When /^I run genprovider with no arguments$/ do
  @output = `ruby #{GENPROVIDER} 2> stderr.out`
  raise if $? == 0
end

When /^I pass "([^"]*)" to genprovider$/ do |arg1| #"
  @output = `ruby #{GENPROVIDER} -n test/test #{File.join(MOFDIR, arg1)} 2> stderr.out`
  raise unless $? == 0
end

When /^I run genprovider with "([^"]*)"$/ do |arg1| #"
  @output = `ruby #{GENPROVIDER} #{arg1} 2> stderr.out`
  raise unless $? == 0
end

When /^I register this with sfcb$/ do
  unless ENV['NO_REGISTER']
    res = system "sudo", "/usr/sbin/provider-register.sh", "-t", "sfcb", "-n", "test/test", "-r", "generated/#{@registration}", "-m", "#{File.join(MOFDIR, 'trivial.mof')}"
    raise unless $? == 0
  end
end

When /^"([^"]*)" is registered$/ do |arg1| #"
  out = `wbemecn http://localhost:5988`
  raise unless out =~ Regexp.new(arg1)
end

When /^I create an instance of "([^"]*)" with "([^"]*)" set to "([^"]*)"$/ do |arg1, arg2, arg3| #"
  cmd = "wbemci 'http://localhost:5988/test/test:#{arg1}.#{arg2}=\"#{arg3}\"' '#{arg2}=\"#{arg3}\"'"
  $stderr.puts "Calling #{cmd}"
  out = `#{cmd}`
  raise unless $? == 0
end

When /^I change the property "([^"]*)" to "([^"]*)"$/ do |arg1, arg2|
end