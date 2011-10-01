#
# provider.rb
#

module Genprovider
  class Provider
    LOG = "@trace_file.puts" # "@log.info"
    def mkcreate c, out
      out.def "create_instance", "context", "result", "reference", "newinst"
      out.puts "#{LOG} \"create_instance ref \#{reference}, newinst \#{newinst.inspect}\""
      out.puts "#{c.name}.new reference, newinst"
      out.puts "result.return_objectpath reference"
      out.puts "result.done"
      out.puts "true"
      out.end
    end

    def mkenum_instance_names c, out
      out.def "enum_instance_names", "context", "result", "reference"
      out.puts "#{LOG} \"enum_instance_names ref \#{reference}\""
      out.puts("#{c.name}.each_name(reference) do |ref|").inc
      out.puts "#{LOG} \"ref \#{ref}\""
      out.puts "result.return_objectpath ref"
      out.end
      out.puts "result.done"
      out.puts "true"
      out.end
    end

    def mkenum_instances c, out
      out.def "enum_instances", "context", "result", "reference", "properties"
      out.puts "#{LOG} \"enum_instances ref \#{reference}, props \#{properties.inspect}\""
      out.puts("#{c.name}.each(reference,properties) do |ref|").inc
      out.puts "#{LOG} \"ref \#{ref}\""
      out.puts "instance = CMPIInstance.new ref"
      out.puts "result.return_instance instance"
      out.end
      out.puts "result.done"
      out.puts "true"
      out.end
    end

    def mkget_instance c, out
      out.def "get_instance", "context", "result", "reference", "properties"
      out.puts "#{LOG} \"get_instance ref \#{reference}, props \#{properties.inspect}\""
      out.puts("#{c.name}.each(reference,properties) do |ref|").inc
      out.puts "#{LOG} \"ref \#{ref}\""
      out.puts "instance = CMPIInstance.new ref"
      out.puts "result.return_instance instance"
      out.puts "break # only return first instance"
      out.end
      out.puts "result.done"
      out.puts "true"
      out.end
    end
    
    def mkset_instance c, out
      out.def "set_instance", "context", "result", "reference", "newinst", "properties"
      out.puts "#{LOG} \"set_instance ref \#{reference}, newinst \#{newinst.inspect}, props \#{properties.inspect}\""
      out.puts("properties.each do |prop|").inc
      out.puts "newinst.send \"\#{prop.name}=\".to_sym, FIXME"
      out.end
      out.puts "result.return_instance newinst"
      out.puts "result.done"
      out.puts "true"
      out.end
    end
    
    def mkdelete_instance c, out
      out.def "delete_instance", "context", "result", "reference"
      out.puts "#{LOG} \"delete_instance ref \#{reference}\""
      out.puts "result.done"
      out.puts "true"
      out.end
    end
    
    def mkquery c, out
      out.comment "query : String"
      out.comment "lang : String"
      out.def "exec_query", "context", "result", "reference", "query", "lang"
      out.puts "#{LOG} \"exec_query ref \#{reference}, query \#{query}, lang \#{lang}\""
      out.puts "result.done" 
      out.puts "true"
      out.end
    end

    def mkcleanup c, out
      out.def "cleanup", "context", "terminating"
      out.puts "#{LOG} \"cleanup terminating? \#{terminating}\""
      out.puts "true"
      out.end
    end

    #
    # generate provider code for class 'c'
    #
    # returns providername
    #

    def initialize c, name, out
      #
      # Header: class name, provider name (Class qualifier 'provider')
      #

      out.comment
      out.comment "Provider #{name} for class #{c.name}"
      out.comment
  
      out.puts("require 'syslog'").puts
      out.puts("require 'cmpi/provider'").puts
      out.puts("module Cmpi").inc

      Genprovider::Class.mkdescription out, c
      #
      # baseclass and interfaces
      #
      providertypes = []
      providertypes << "InstanceProvider" if c.instance?
      providertypes << "MethodProvider" if c.method?
      providertypes << "AssociationProvider" if c.association?
      providertypes << "IndicationProvider" if c.indication?

      if providertypes.empty?
	STDERR.puts "Assuming that #{c.name} defines an Instance" 
	providertypes << "InstanceProvider"
      end

      out.puts("class #{name} < #{providertypes.first}").inc
#      out.puts("$: << '#{out.dir}'").puts "require '#{c.name.decamelize}'"
      out.puts "require File.join(File.dirname(__FILE__), '#{c.name.decamelize}')"
      out.puts
      providertypes.each do |t|
	out.puts "include #{t}IF"
      end
      out.puts
      out.puts("def initialize broker").inc
#      out.puts("@log = Syslog.open(\"#{name}\")")
      out.puts "@trace_file = STDERR"
      out.puts("if ENV['SBLIM_TRACE']").inc
      out.puts("f = ENV['SBLIM_TRACE_FILE']")
      out.puts("if f").inc
      out.puts "@trace_file = File.open f, 'a+'"
      out.puts "raise \"Cannot open SBLIM_TRACE_FILE \#{f}\" unless @trace_file"
      out.end
      out.end
      out.puts("#{LOG} \"Initializing \#{self}\"")
      out.puts "super broker"
      out.end
      if c.instance?
	mkcreate c, out
	mkenum_instance_names c, out
	mkenum_instances c, out
	mkget_instance c, out
	mkset_instance c, out
	mkdelete_instance c, out
	mkquery c, out
	mkcleanup c, out
      end
      out.end # class
      out.end # module
    end
  end
end

