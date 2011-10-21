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
    def properties filter
      overrides = {}
      c = @klass
      while c
	c.features.each do |f|
	  next unless f.property?
	  next if overrides[f.name] # overriden in child class
	  overrides[f.name] = true if f.qualifiers["override"]
	  if f.key?
	    next if filter == :nokeys
	  else
	    next if filter == :keys
	  end
	  yield f, c
	end
        c = c.parent
      end
    end

    LOG = "@trace_file.puts" # "@log.info"
    
    def bounds property, *args
      s = ""
      args.each do |n|
	v = property.send(n)
	s << "#{n} #{v.value} " if v
      end
      s
    end

    #
    # generate line to set a property
    # i.e. result.Property = nil # property_type + valuemap
    #
    def property_setter_line property, klass, result_name = "result"
      valuemap = property.ValueMap
      values = property.Values
      type = property.type
      if valuemap
	firstval = values ? values[0] : valuemap[0]
	if firstval.to_s =~ /\s/
	  firstval = "send(#{firstval.to_sym.inspect})"
	end
	default = "#{property.name}.#{firstval}"
      else
	default = "nil"
      end
      default = "[#{default}]" if type.array?
      bounds = bounds property, :MaxLen, :Max, :Min
      "#{result_name}.#{property.name} = #{default} # #{type} #{bounds} (-> #{klass.name})"
    end
    #
    # Class#each
    #
    def mkeach
      @out.puts "private"
      @out.comment
      @out.comment "Iterator for names and instances"
      @out.comment " yields references matching reference and properties"
      @out.comment
      @out.def "each", "context", "reference", "properties = nil", "want_instance = false"
      @out.puts("if want_instance").inc
      @out.puts "result = Cmpi::CMPIObjectPath.new reference.namespace, #{@klass.name.inspect}"
      @out.puts "result = Cmpi::CMPIInstance.new result"
      @out.dec.puts("else").inc
      @out.puts "result = Cmpi::CMPIObjectPath.new reference.namespace, #{@klass.name.inspect}"
      @out.end
      @out.puts
      @out.comment "Set key properties"
      @out.puts
      properties :keys do |prop, klass|
	@out.puts(property_setter_line prop, klass)
      end
      @out.puts("unless want_instance").inc
      @out.puts "yield result"
      @out.puts "return"
      @out.end
      @out.puts
      @out.comment "Instance: Set non-key properties"
      @out.puts
      properties :nokeys do |prop, klass|
	deprecated = prop.qualifiers["deprecated"]
	required = prop.qualifiers["required"]
	if required
	  @out.comment "Required !"
	  @out.puts "#{property_setter_line prop, klass}"
	else
	  @out.comment "Deprecated !" if deprecated
	  # using @out.comment would break the line at col 72
	  @out.puts "# #{property_setter_line prop, klass}"
	end
      end
      @out.puts "yield result"
      @out.end
      @out.puts "public"
    end
    #
    # Generate Class#initialize
    #
    def mknew
      @out.comment
      @out.comment "Provider initialization"
      @out.comment
      @out.def "initialize", "name", "broker", "context"
      @out.puts "@trace_file = STDERR"
      @out.puts "super name, broker, context"
      @out.end
    end

    #
    # Generate create_instance
    #
    def mkcreate
      @out.def "create_instance", "context", "result", "reference", "newinst"
      @out.puts "#{LOG} \"create_instance ref \#{reference}, newinst \#{newinst.inspect}\""
      @out.puts "#{@klass.name}.new reference, newinst"
      @out.puts "result.return_objectpath reference"
      @out.puts "result.done"
      @out.puts "true"
      @out.end
    end

    #
    # Generate enum_instance_names
    #
    def mkenum_instance_names
      @out.def "enum_instance_names", "context", "result", "reference"
      @out.puts "#{LOG} \"enum_instance_names ref \#{reference}\""
      @out.puts("each(context, reference) do |ref|").inc
      @out.puts "#{LOG} \"ref \#{ref}\""
      @out.puts "result.return_objectpath ref"
      @out.end
      @out.puts "result.done"
      @out.puts "true"
      @out.end
    end

    #
    # Generate enum_instances
    #
    def mkenum_instances
      @out.def "enum_instances", "context", "result", "reference", "properties"
      @out.puts "#{LOG} \"enum_instances ref \#{reference}, props \#{properties.inspect}\""
      @out.puts("each(context, reference, properties, true) do |instance|").inc
      @out.puts "#{LOG} \"instance \#{instance}\""
      @out.puts "result.return_instance instance"
      @out.end
      @out.puts "result.done"
      @out.puts "true"
      @out.end
    end

    #
    # Generate get_instance
    #
    def mkget_instance
      @out.def "get_instance", "context", "result", "reference", "properties"
      @out.puts "#{LOG} \"get_instance ref \#{reference}, props \#{properties.inspect}\""
      @out.puts("each(context, reference, properties, true) do |instance|").inc
      @out.puts "#{LOG} \"instance \#{instance}\""
      @out.puts "result.return_instance instance"
      @out.puts "break # only return first instance"
      @out.end
      @out.puts "result.done"
      @out.puts "true"
      @out.end
    end

    #
    # Generate set_instance
    #
    def mkset_instance
      @out.def "set_instance", "context", "result", "reference", "newinst", "properties"
      @out.puts "#{LOG} \"set_instance ref \#{reference}, newinst \#{newinst.inspect}, props \#{properties.inspect}\""
      @out.puts("properties.each do |prop|").inc
      @out.puts "newinst.send \"\#{prop.name}=\".to_sym, FIXME"
      @out.end
      @out.puts "result.return_instance newinst"
      @out.puts "result.done"
      @out.puts "true"
      @out.end
    end

    #
    # Generate delete_instance
    #
    def mkdelete_instance
      @out.def "delete_instance", "context", "result", "reference"
      @out.puts "#{LOG} \"delete_instance ref \#{reference}\""
      @out.puts "result.done"
      @out.puts "true"
      @out.end
    end

    #
    # Generate exec_query
    #
    def mkquery
      @out.comment "query : String"
      @out.comment "lang : String"
      @out.def "exec_query", "context", "result", "reference", "query", "lang"
      @out.puts "#{LOG} \"exec_query ref \#{reference}, query \#{query}, lang \#{lang}\""
      @out.puts "result.done"
      @out.puts "true"
      @out.end
    end

    #
    # Generate cleanup
    #
    def mkcleanup
      @out.def "cleanup", "context", "terminating"
      @out.puts "#{LOG} \"cleanup terminating? \#{terminating}\""
      @out.puts "true"
      @out.end
    end

    def mktypemap
      @out.def("self.typemap")
      @out.puts("{").inc
      properties :all do |property, klass|
	t = property.type
	a = ""
	if t.array?
	  a = "A"
	  t = t.type
	end
	@out.puts "#{property.name.inspect} => Cmpi::#{t}#{a},"
      end
      @out.dec.puts "}"
      @out.end
    end
    #
    # Generate valuemap classes
    #
    def mkvaluemaps
      properties :all do |property, klass|
	t = property.type
	# get the Values and ValueMap qualifiers
	valuemap = property.ValueMap
	next unless valuemap
	values = property.Values
	@out.puts
	@out.puts("class #{property.name} < Cmpi::ValueMap").inc
	@out.def "self.map"
	@out.puts("{").inc
	# get to the array
	valuemap = valuemap.value
	# values might be nil, then only ValueMap given
	if values
	  values = values.value
	elsif !t.matches?(String)
	  raise "ValueMap missing Values for property #{property.name} with non-string type #{t}"
	end
	loop do
	  val = values.shift if values
	  map = valuemap.shift
	  if val.nil? && values
	    # have values but its empty
	    break unless map # ok, both nil
	    raise "#{property.name}: Values empty, ValueMap #{map}"
	  end
	  unless map
	    break unless val # ok, both nil
	    raise "#{property.name}: Values #{val}, ValueMap empty"
	  end
	  if val
	    if map =~ /\.\./
	      @out.comment "#{val.inspect} => #{map},"
	    else
	      @out.puts "#{val.inspect} => #{map},"
	    end
	  else
	    @out.puts "#{map.inspect} => #{map.to_sym.inspect},"
	  end
	end
	@out.dec.puts "}"
	@out.end
	@out.end
      end
    end

    def providertypes
      mask = 0
      c = @klass
      while c
	mask |= 1 if c.instance?
	mask |= 2 if c.method?
	mask |= 4 if c.association?
	mask |= 8 if c.indication?
	c = c.parent
      end
      res = []
      res << "InstanceProvider" if mask & 1
      res << "MethodProvider" if mask & 2
      res << "AssociationProvider" if mask & 4
      res << "IndicationProvider" if mask & 8

      if res.empty?
	STDERR.puts "Assuming that #{@klass.name} defines an Instance"
	res << "InstanceProvider"
      end
      res
    end

    #
    # generate provider code for class 'c'
    #
    # returns providername
    #

    def initialize c, name, out
      @klass = c
      @out = out

      #
      # Header: class name, provider name (Class qualifier 'provider')
      #

      @out.comment
      @out.comment "Provider #{name} for class #{@klass.name}:#{@klass.class}"
      @out.comment

      @out.puts("require 'syslog'").puts
      @out.puts("require 'cmpi/provider'").puts
      @out.puts("module Cmpi").inc

      Genprovider::Class.mkdescription @out, @klass
      if @klass.parent
	Genprovider::Class.mkdescription @out, @klass.parent
      end
      p = providertypes
      @out.puts("class #{name} < #{p.shift}").inc

      @out.puts
      p.each do |t|
	@out.puts "include #{t}IF"
      end
      mkeach
      @out.puts
      mknew
      @out.puts
      if @klass.instance? || providertypes.empty?
	mkcreate
	@out.puts
	mkenum_instance_names
	@out.puts
	mkenum_instances
	@out.puts
	mkget_instance
	@out.puts
	mkset_instance
	@out.puts
	mkdelete_instance
	@out.puts
	mkquery
	@out.puts
	mkcleanup
	@out.puts
	mktypemap
	@out.puts
	mkvaluemaps
      end
      @out.end # class
      @out.end # module
    end
  end
end

