Given /^I have a registration "([^"]*)"$/ do |arg1| #"
  @registration = arg1
end

When /^I register this with sfcb$/ do
  unless ENV['NO_REGISTER']
    $sfcb.stop
    res = system "sudo", "/usr/sbin/cmpi-provider-register", "-v", "-g", $sfcb.stage_dir, "-t", "sfcb", "-n", NAMESPACE, "-d", $sfcb.dir
    raise unless $? == 0
    $sfcb.start
  end
end

When /^"([^"]*)" is registered in namespace "([^"]*)"$/ do |arg1,arg2| #"
  out = `wbemecn #{$sfcb.url}/#{arg2}`
  raise unless out =~ Regexp.new(arg1)
end
