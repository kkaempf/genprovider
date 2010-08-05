Then /^I should see a short usage explanation$/ do
  @output =~ /Usage:/
end

Then /^I should see an "([^"]*)" file$/ do |arg1| #"
  File.exists? arg1
end

Then /^I should see an error message$/ do
  File.stat("stderr.out").size > 0
end

Then /^comment lines should not exceed (\d+) characters$/ do |arg1| #"
  maxcolumn = arg1.to_i
  @output.scan(/^\s*\#.*$/).each do |l|
    return false if l.chomp.size > maxcolumn
  end
  true
end

Then /^its output should be accepted by Ruby$/ do
  Dir.foreach("generated") do |f|
    next unless f =~ /.rb$/
    res = system "ruby", File.join("generated", f)
    raise unless res && $? == 0
  end
end

Then /^I should see "([^"]*)" in enumerated class names$/ do |arg1| #"
  out = `wbemecn http://localhost:5988`
  raise unless out =~ Regexp.new(arg1)
end

Then /^I should see "([^"]*)" in namespace "([^"]*)"$/ do |arg1, arg2|
  out = `wbemecn http://localhost:5988/#{arg2}`
  raise unless out =~ Regexp.new(arg1)
end
  
Then /^I should see "([^"]*)" in enumerated instance names$/ do |arg1| #"
  out = `wbemein http://localhost:5988/test/test:#{arg1}`
  raise unless out =~ Regexp.new(arg1)
end

  