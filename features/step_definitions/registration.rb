When /^I register "([^"]*)" using "([^"]*)" with sfcb$/ do |mofpath,regname|
  return if ENV['NO_REGISTER']
  $sfcb.stop
  tmpregname = File.join(TMPDIR, File.basename(regname, ".registration") + ".reg")
  sfcb_transform_to tmpregname, File.join("#{TOPLEVEL}/samples/registration", regname)
  cmd = "sfcbstage -s #{$sfcb.stage_dir} -n #{NAMESPACE} -r #{tmpregname} #{File.join(TOPLEVEL, mofpath)}"
#  STDERR.puts cmd
  res = `#{cmd} 2> #{TMPDIR}/sfcbstage.err`
  raise unless $? == 0
  cmd = "sfcbrepos -f -s #{$sfcb.stage_dir} -r #{$sfcb.registration_dir}"
#  STDERR.puts cmd
  res = `#{cmd} 2> #{TMPDIR}/sfcbrepos.err`
  raise unless $? == 0
  $sfcb.start
end

When /^"([^"]*)" is registered in namespace "([^"]*)"$/ do |arg1,arg2| #"
  out = `wbemecn #{$sfcb.url}/#{arg2} 2> #{TMPDIR}/wbemecn.err`
#  STDERR.puts "wbemecn expects '#{arg1}', returns '#{out}'"
  raise unless out =~ Regexp.new(arg1)
end
