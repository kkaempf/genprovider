Then /^I should see a short usage explanation$/ do
  @output =~ /Usage:/
end

Then /^I should see an "([^"]*)" file$/ do |arg1| #"
  File.exists? arg1
end

Then /^I should see an error message$/ do
  File.stat(File.join(TMPDIR,"std.err")).size > 0
end

Then /^comment lines should not exceed (\d+) characters$/ do |arg1| #"
  maxcolumn = arg1.to_i
  @output.scan(/^\s*\#.*$/).each do |l|
    return false if l.chomp.size > maxcolumn
  end
  true
end

Then /^its output should be accepted by Ruby$/ do
  Dir.foreach($sfcb.providers_dir) do |f|
    next unless f =~ /.rb$/
    res = system "ruby", File.join($sfcb.providers_dir, f)
    raise unless res && $? == 0
  end
end

When /^I run genprovider with no arguments$/ do
  @output = `ruby -I #{LIBDIR} #{GENPROVIDER} 2> #{TMPDIR}/std.err`
  raise if $? == 0
end

When /^I pass "([^"]*)" to genprovider$/ do |arg1| #"
  cmd = "ruby -I #{LIBDIR} #{GENPROVIDER} -f -n #{NAMESPACE} -o #{$sfcb.providers_dir} qualifiers.mof #{File.join(MOFDIR, arg1)} 2> #{TMPDIR}/std.err"
  STDERR.puts "Run #{cmd}"
  @output = `#{cmd}`
  raise unless $? == 0
end

When /^I run genprovider with "([^"]*)"$/ do |arg1| #"
  @output = `ruby -I #{LIBDIR} #{GENPROVIDER} #{arg1} 2> #{TMPDIR}/std.err`
  raise unless $? == 0
end
