def sfcb_transform_to outfile, *regfiles
  File.open(outfile, "a") do |out|
    regfiles.each do |regfile|
      File.open(regfile, "r") do |f|
	while (l = f.gets)
	  next if l =~ /^\s*#.*$/
	  l.chomp!
	  next if l.empty?
	  #  0         1         2            3              4..-1
	  #  classname namespace providername providermodule caps
	  reg = l.split(" ")
	  raise unless reg.size > 4
	  out.puts "[#{reg[0]}]"
	  out.puts "  provider: #{reg[2]}"
	  out.puts "  location: #{reg[3]}"
	  out.puts "  type: #{reg[4..-1].join(' ')}"
	  out.puts "  namespace: #{reg[1]}"
	end
      end
    end
  end
end
