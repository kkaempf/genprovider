When /^I register "([^"]*)" using "([^"]*)" with sfcb$/ do |arg1,arg2|
  unless ENV['NO_REGISTER']
    $sfcb.stop
    cmd = "sfcbstage -s #{$sfcb.stage_dir} -n #{NAMESPACE} -r #{File.join($sfcb.providers_dir, arg2)} #{File.join(MOFDIR, arg1)}"
    STDERR.puts cmd
    res = `#{cmd}`
    raise unless $? == 0
    cmd = "sfcbrepos -f -s #{$sfcb.stage_dir} -r #{$sfcb.registration_dir}"
    STDERR.puts cmd
    res = `#{cmd}`
    raise unless $? == 0
    $sfcb.start
  end
end

When /^"([^"]*)" is registered in namespace "([^"]*)"$/ do |arg1,arg2| #"
  out = `wbemecn #{$sfcb.url}/#{arg2}`
  raise unless out =~ Regexp.new(arg1)
end
