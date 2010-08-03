#!/usr/bin/ruby
#
# genprovider
#
#  Generate Ruby provider templates for use with cmpi-bindings
#
# == Usage
#
# genprovider.rb [-d] [-h] [-q] [-I <includedir>] [-o <output>] <moffile> [<moffile> ...]
#
# -d:
#   turn on debugging
# -h:
#   show (this) help
# -q:
#   be quiet
# -I <includedir>
#   additional include directories to search
# -o <outputdir>
#   directory to write generated files, defaults to 'generated'
# <moffile>
#   .mof files to read
#
require 'rdoc/usage'

require File.join(File.dirname(__FILE__), "..", "mofparser","parser","mofparser")
require 'pathname'
require 'fileutils'

require File.join(File.dirname(__FILE__), 'output')
require File.join(File.dirname(__FILE__), 'mkclass')
require File.join(File.dirname(__FILE__), 'mkprovider')
require File.join(File.dirname(__FILE__), 'mkregistration')

class String
  def decamelize
    self.gsub(/[A-Z]+/) do |match|
      # puts "#{$`}<#{match}>#{$'}"
      if $`.empty? || $`[-1,1] == "_" || $'.empty? || $'[0,1] == "_"
	match.downcase
      else
	"_#{match.downcase}"
      end
    end
  end
end

cim_current = "/usr/share/mof/cim-current"

moffiles, options = Mofparser.argv_handler "genprovider", ARGV
if moffiles.empty?
  $stderr.puts "No .mof files given"
  exit 1
end
if options[:namespace].nil? || options[:namespace].empty?
  $stderr.puts "Namespace required for registration"
  exit 1
end
#RDoc::usage 

options[:style] ||= :cim;
options[:includes] ||= []
options[:includes].unshift(Pathname.new ".")
options[:includes].unshift(Pathname.new cim_current)

Dir.new(cim_current).each do |d|
  next if d[0,1] == "."
  fullname = File.join(cim_current, d)
  next unless File.stat(fullname).directory?
  options[:includes].unshift(Pathname.new fullname)
end

moffiles.unshift "qualifiers.mof" unless moffiles.include? "qualifiers.mof"
#moffiles.unshift "qualifiers_optional.mof" unless moffiles.include? "qualifiers_optional.mof"

parser = Mofparser.new options

begin
  result = parser.parse moffiles
rescue Exception => e
  parser.error_handler e
  exit 1
end

exit 0 unless result

#
# collect classes to find parent classes
#
classes = {}
result.each do |name, res|
  res.classes.each do |c|
    classes[c.name] = c unless classes.has_key? c.name
  end
end

classes.each_value do |c|
  next unless c.superclass
  next if classes.has_key? c.superclass
  # parent unknown
  #  try parent.mof
  begin
    parser = Mofparser.new options
    result = parser.parse ["qualifiers.mof", "#{c.superclass}.mof"]
    if result
      result.each_value do |r|
	r.classes.each do |parent|
	  if parent.name == c.superclass
	    c.parent = parent
	    classes[parent.name] = parent
	  end
	end
      end
    else
      $stderr.puts "Warn: Parent #{c.superclass} of #{c.name} not known"
    end
  rescue Exception => e
    parser.error_handler e
  end
end

outdir = options[:output] || "generated"
Dir.mkdir outdir rescue Errno::EEXIST

classes.each_value do |c|
  dcname = c.name.decamelize
  out = Output.new File.join(outdir,"#{dcname}.rb")
  mkclass c, out
  # don't create providers for abstract base classes
  next if c.name =~ /^CIM_/
  
  out = Output.new File.join(outdir,"#{dcname}_provider.rb")
  providername = mkprovider c, out
  out = Output.new File.join(outdir,"#{dcname}.registration")
  mkregistration c, options[:namespace], providername, out

end
