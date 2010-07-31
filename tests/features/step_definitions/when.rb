When /^I run genprovider with no arguments$/ do
  @output = `ruby #{GENPROVIDER} 2> stderr.out`
  raise unless $? == 0
end

When /^I pass "([^"]*)" to genprovider$/ do |arg1| #"
  @output = `ruby #{GENPROVIDER} #{File.join(MOFDIR, arg1)} 2> stderr.out`
  raise unless $? == 0
end
