#
# mkprovider.rb
#

#
# generate 'create_instance'
#

def mkcreate c, out
  out.puts("def create_instance context, result, reference, newinst").inc
  out.puts("@log.info \"create_instance ref #{reference}, newinst #{newinst}\"")
  out.printf "obj = #{c.name}.new"
  keyargs c, out
  out.puts("result.return_objectpath reference")
  out.puts("result.done")
  out.puts("true")
  out.puts.dec.puts("end")
end

#
# generate provider code for class 'c'
#
# returns providername
#

def mkprovider c, name, out
  #
  # Header: class name, provider name (Class qualifier 'provider')
  #

  out.comment
  out.comment "Provider #{name} for class #{c.name}"
  out.comment
  
  out.puts("require 'syslog'").puts
  out.puts("require 'cmpi/provider'").puts
  out.puts("module Cmpi").inc

  mkdescription out, c
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
  out.puts("@log = Syslog.open(\"#{providername}\")")
  out.puts("@log.info 'Initializing #{self}'")
  out.dec.puts "end"
  if c.instance?
    mkcreate c, out
  else
    out.puts "
    def enum_instance_names context, result, reference
    end
    def enum_instances context, result, reference, properties
    end
    def get_instance context, result, reference, properties
    end
    def set_instance context, result, reference, newinst, properties
    end
    def delete_instance context, result, reference
    end
    # query : String
    # lang : String 
    def exec_query context, result, reference, query, lang
    end
    def cleanup context, terminating
    end"
  end
  out.dec.puts("end") # class
  out.dec.puts "end" # module
end

#------------------------------------------------------------------
