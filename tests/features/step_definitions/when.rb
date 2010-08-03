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
  res = system "sudo", "/usr/sbin/provider-register.sh", "-t", "sfcb", "-r", "generated/#{@registration}", "-m", "#{File.join(MOFDIR, 'trivial.mof')}"
  raise unless $? == 0
end
