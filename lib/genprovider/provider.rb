#
# provider.rb
#

module CIM
  class ClassFeature
    def method_missing name
      qualifiers[name]
    end
  end
  class Qualifier
    def method_missing name, *args
      if name == :"[]"
	value[*args]
      else
	super name, *args
      end
    end
  end
end


module Genprovider
  class Provider
    #
    # iterate properties
    #  filter = :keys  # keys only
    #           :nokey # non-keys only
    #           :all   # all
    def properties c, filter
      while c
	c.features.each do |f|
	  next unless f.property?
	  if f.key?
	    next if filter == :nokeys
	  else
	    next if filter == :keys
	  end
	  yield f
	end
        c = c.parent
      end
    end

    LOG = "@trace_file.puts" # "@log.info"
    #
    # generate line to set a property
    # i.e. result.Property = nil # property_type + valuemap
    #
    def property_setter_line property, result_name = "result"
      values = property.Values
      type = property.type
      if values
        default = "#{property.name}.#{values[0]}"
      else
	default = "nil"
      end
      default = "[#{default}]" if type.array?

      "#{result_name}.#{property.name} = #{default} # #{type}"
    end
    #
    # Class#each
    #
    def mkeach c, out
      out.puts "private"
      out.comment
      out.comment "Iterator for names and instances"
      out.comment " yields references matching reference and properties"
      out.comment
      out.def "each", "reference", "properties = nil", "want_instance = false"
      out.puts "result = Cmpi::CMPIObjectPath.new reference"
      out.puts
      out.comment "Set key properties"
      out.puts
      properties(c, :keys) do |prop|
	out.puts(property_setter_line prop)
      end
      out.puts "yield result unless want_instance"
      out.puts
      out.comment "Set non-key properties"
      out.puts
      properties(c, :nokeys) do |prop|
	# using out.comment would break the line at col 72
	out.puts "# #{property_setter_line prop}"
      end
      out.puts "yield result"
      out.end
      out.puts "public"
    end
    #
    # Generate Class#initialize
    #
    def mknew c,out
      out.comment
      out.comment "Provider initialization"
      out.comment
      out.def "initialize", "name", "broker", "context"
      out.puts "@trace_file = STDERR"
      out.puts "super name, broker, context"
      out.end
    end

    #
    # Generate create_instance
    #
    def mkcreate c, out
      out.def "create_instance", "context", "result", "reference", "newinst"
      out.puts "#{LOG} \"create_instance ref \#{reference}, newinst \#{newinst.inspect}\""
      out.puts "#{c.name}.new reference, newinst"
      out.puts "result.return_objectpath reference"
      out.puts "result.done"
      out.puts "true"
      out.end
    end

    #
    # Generate enum_instance_names
    #
    def mkenum_instance_names c, out
      out.def "enum_instance_names", "context", "result", "reference"
      out.puts "#{LOG} \"enum_instance_names ref \#{reference}\""
      out.puts("each(reference) do |ref|").inc
      out.puts "#{LOG} \"ref \#{ref}\""
      out.puts "result.return_objectpath ref"
      out.end
      out.puts "result.done"
      out.puts "true"
      out.end
    end

    #
    # Generate enum_instances
    #
    def mkenum_instances c, out
      out.def "enum_instances", "context", "result", "reference", "properties"
      out.puts "#{LOG} \"enum_instances ref \#{reference}, props \#{properties.inspect}\""
      out.puts("each(reference, properties, true) do |ref|").inc
      out.puts "#{LOG} \"ref \#{ref}\""
      out.puts "instance = CMPIInstance.new ref"
      out.puts "result.return_instance instance"
      out.end
      out.puts "result.done"
      out.puts "true"
      out.end
    end

    #
    # Generate get_instance
    #
    def mkget_instance c, out
      out.def "get_instance", "context", "result", "reference", "properties"
      out.puts "#{LOG} \"get_instance ref \#{reference}, props \#{properties.inspect}\""
      out.puts("each(reference, properties, true) do |ref|").inc
      out.puts "#{LOG} \"ref \#{ref}\""
      out.puts "instance = CMPIInstance.new ref"
      out.puts "result.return_instance instance"
      out.puts "break # only return first instance"
      out.end
      out.puts "result.done"
      out.puts "true"
      out.end
    end

    #
    # Generate set_instance
    #
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

    #
    # Generate delete_instance
    #
    def mkdelete_instance c, out
      out.def "delete_instance", "context", "result", "reference"
      out.puts "#{LOG} \"delete_instance ref \#{reference}\""
      out.puts "result.done"
      out.puts "true"
      out.end
    end

    #
    # Generate exec_query
    #
    def mkquery c, out
      out.comment "query : String"
      out.comment "lang : String"
      out.def "exec_query", "context", "result", "reference", "query", "lang"
      out.puts "#{LOG} \"exec_query ref \#{reference}, query \#{query}, lang \#{lang}\""
      out.puts "result.done"
      out.puts "true"
      out.end
    end

    #
    # Generate cleanup
    #
    def mkcleanup c, out
      out.def "cleanup", "context", "terminating"
      out.puts "#{LOG} \"cleanup terminating? \#{terminating}\""
      out.puts "true"
      out.end
    end

    #
    # Generate valuemap classes
    #
    def mkvaluemaps c, out
      properties(c,:all) do |property|
	# get the Values and ValueMap qualifiers
	values = property.Values
	next unless values
	valuemap = property.ValueMap
	out.puts
	out.puts("class #{property.name}").inc
	out.puts("MAP = {").inc
	# get to the array
	values = values.value
	valuemap = valuemap.value
	loop do
	  val = values.shift
	  map = valuemap.shift
	  unless val
	    break unless map # ok, both nil
	    raise "#{property.name}: Values empty, ValueMap #{map}"
	  end
	  unless map
	    break unless val # ok, both nil
	    raise "#{property.name}: Values #{val}, ValueMap empty"
	  end
	  if map =~ /\.\./
	    out.comment "#{val.inspect} => #{map},"
	  else
	    out.puts "#{val.inspect} => #{map},"
	  end
	end
	out.dec.puts "}"
	out.end
      end
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

      out.puts("class #{name} < #{providertypes.shift}").inc
      out.puts
      providertypes.each do |t|
	out.puts "include #{t}IF"
      end
      mkeach c,out
      out.puts
      mknew c,out
      out.puts
      if c.instance? || providertypes.empty?
	mkcreate c, out
	out.puts
	mkenum_instance_names c, out
	out.puts
	mkenum_instances c, out
	out.puts
	mkget_instance c, out
	out.puts
	mkset_instance c, out
	out.puts
	mkdelete_instance c, out
	out.puts
	mkquery c, out
	out.puts
	mkcleanup c, out
	out.puts
	mkvaluemaps c, out
      end
      out.end # class
      out.end # module
    end
  end
end

