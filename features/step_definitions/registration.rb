When /^I register "([^"]*)" using "([^"]*)" with sfcb$/ do |mofname,regname|
  unless ENV['NO_REGISTER']
    require 'tmpdir'
    $sfcb.stop
    tmpregname = File.join(Dir.tmpdir, File.basename(regname, ".registration") + ".reg")
    sfcb_transform_to tmpregname, File.join($sfcb.providers_dir, regname)
    cmd = "sfcbstage -s #{$sfcb.stage_dir} -n #{NAMESPACE} -r #{tmpregname} #{File.join(MOFDIR, mofname)}"
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
