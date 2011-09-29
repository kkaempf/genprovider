Given /^I have a mof file called "([^"]*)"$/ do |arg1|
  File.exists?("mof/#{arg1}")
end
