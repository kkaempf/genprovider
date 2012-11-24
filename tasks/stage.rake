#
# Stage provider to sfcb stage dir and run sfcbrepos
#

task :stage do
  STAGEDIR = "/var/lib/sfcb/stage"
  Dir.glob("samples/sfcb.reg/*.reg") do |regfile|
    moffile = File.basename(regfile, ".reg")
    moffile = "features/mof/#{moffile}.mof"
    puts "Copying #{regfile} and #{moffile}"
    system("cp #{regfile} #{STAGEDIR}/regs")
    system("cp #{moffile} #{STAGEDIR}/mofs/root/cimv2")
  end
  puts "Creating sfcb repo"
  system "sfcbrepos -f"
end
