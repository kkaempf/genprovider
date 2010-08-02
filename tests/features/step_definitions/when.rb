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
