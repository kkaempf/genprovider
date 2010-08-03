Given /^nothing$/ do
  # no-op
end

Given /^I have a mof file called "([^"]*)"$/ do |arg1|
  File.exists?("mof/#{arg1}")
end

Given /^I have a registration "([^"]*)"$/ do |arg1| #"
  @registration = arg1
end