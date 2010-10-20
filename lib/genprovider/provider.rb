#
# provider.rb
#

#
# generate 'create_instance'
#

module Genprovider
  class Provider
    LOG = "$stderr.puts" # "@log.info"
    def mkcreate c, out
      out.puts("def create_instance context, result, reference, newinst").inc
      out.puts "#{LOG} \"create_instance ref \#{reference}, newinst \#{newinst.inspect}\""
      out.printf "obj = #{c.name}.new"
      first = true
      c.each_key do |key|
	out.printf "," unless first
	first = false
	out.printf " newinst[\"#{key.name}\"]"
      end
      out.puts
      out.puts "result.return_objectpath reference"
      out.puts "result.done"
      out.puts "true"
      out.dec.puts "end"
    end

    def mkenum_instance_names c, out
      out.puts("def enum_instance_names context, result, reference").inc
      out.puts "#{LOG} \"enum_instance_names ref \#{reference}\""
      out.puts("#{c.name}.each_name do |key,val|").inc
      out.puts "reference[key] = val"
      out.puts "result.return_objectpath reference"
      out.dec.puts "end"
      out.puts "result.done"
      out.puts "true"
      out.dec.puts "end"
    end

    def mkenum_instances c, out
      out.puts("def enum_instances context, result, reference, properties").inc
      out.puts "#{LOG} \"enum_instance_names ref \#{reference}, props \#{properties.inspect}\""
      out.puts("#{c.name}.each(properties) do |instance|").inc
      out.puts "result.return_instance instance"
      out.dec.puts "end"
      out.puts "result.done"
      out.puts "true"
      out.dec.puts "end"
    end

    def mkget_instance c, out
      out.puts("def get_instance context, result, reference, properties").inc
      out.puts "#{LOG} \"get_instance ref \#{reference}, props \#{properties.inspect}\""
      out.puts("#{c.name}.each(properties) do |instance|").inc
      out.puts "result.return_instance instance"
      out.puts "break # only return first instance"
      out.dec.puts "end"
      out.puts "result.done"
      out.puts "true"
      out.dec.puts "end"
    end
    
    def mkset_instance c, out
      out.puts("def set_instance context, result, reference, newinst, properties").inc
      out.puts "#{LOG} \"set_instance ref \#{reference}, newinst \#{newinst.inspect}, props \#{properties.inspect}\""
      out.puts "result.done"
      out.puts "true"
      out.dec.puts "end"
    end
    
    def mkdelete_instance c, out
      out.puts("def delete_instance context, result, reference").inc
      out.puts "#{LOG} \"delete_instance ref \#{reference}\""
      out.puts "result.done"
      out.puts "true"
      out.dec.puts "end"
    end
    
    def mkquery c, out
      out.comment "query : String"
      out.comment "lang : String"
      out.puts("def exec_query context, result, reference, query, lang").inc
      out.puts "#{LOG} \"exec_query ref \#{reference}, query \#{query}, lang \#{lang}\""
      out.puts "result.done" 
      out.puts "true"
      out.dec.puts "end"
    end

    def mkcleanup c, out
      out.puts("def cleanup context, terminating").inc
      out.puts "#{LOG} \"cleanup terminating? \#{terminating}\""
      out.puts "true"
      out.dec.puts "end"
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

      raise "Unknown provider type" if providertypes.empty?

      out.puts("class #{name} < #{providertypes.shift}").inc
      out.puts("$: << '#{out.dir}'").puts "require '#{c.name.decamelize}'"
      out.puts
      providertypes.each do |t|
	out.puts "include #{t}IF"
      end
      out.puts
      out.puts("def initialize broker").inc
#      out.puts("@log = Syslog.open(\"#{name}\")")
      out.puts("#{LOG} 'Initializing #{self}'")
      out.dec.puts "end"
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
      out.dec.puts "end" # class
      out.dec.puts "end" # module
    end
  end
end

