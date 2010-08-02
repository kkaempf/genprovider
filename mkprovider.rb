#
# mkprovider.rb
#

#
# generate provider code for class 'c'
#
# returns providername
#

def mkprovider c, out
  #
  # Header: class name, provider name (Class qualifier 'provider')
  #
  providername = c.name
  p = c.qualifiers["provider", :string]

  providername = p.value if p
  out.comment
  out.comment "Provider #{providername} for class #{c.name}"
  out.comment
  
  out.puts("require 'cmpi'").puts
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

  out.puts("class #{c.name}Provider < #{providertypes.shift}").inc
  out.puts "require '#{c.name.decamelize}'"
  out.puts
  providertypes.each do |t|
    out.puts "include #{t}IF"
  end
  if c.instance?
    out.puts "
    def create_instance context, result, reference, newinst
      # extract key props from newinst
      # call #{c.name}.new(keyprops)
    end
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
    end"
  end
  out.dec.puts("end") # class
  out.dec.puts "end" # module
  providername
end

#------------------------------------------------------------------
