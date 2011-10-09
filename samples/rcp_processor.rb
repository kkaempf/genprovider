#
# Provider RCP_Processor for class RCP_Processor
#
require 'syslog'

require 'cmpi/provider'

require 'socket'

module Cmpi
  #
  # Realisation of CIM_Processor in Ruby
  #
  class RCP_Processor < InstanceProvider
    
    private
    #
    # Iterator for names and instances
    #  yields references matching reference and properties
    #
    def each( reference, properties = nil, want_instance = false )
      File.open("/proc/cpuinfo") do |f|
	result = nil
	while l = f.gets
	  k,v = l.chomp.split ":"
	  next unless k
	  k.strip!
	  v.strip! if v
	  if k =~ /processor/
	    yield result if result
	    result = Cmpi::CMPIObjectPath.new reference
	    result.SystemCreationClassName = "RCP_Processor"
	    result.SystemName = Socket.gethostbyname(Socket.gethostname).first
	    result.CreationClassName = result.SystemCreationClassName
	    result.DeviceID = v
	  end
	  next unless want_instance

	end
	yield result if result
      end
    end
    public
    
    #
    # Provider initialization
    #
    def initialize( name, broker, context )
      @trace_file = STDERR
      super name, broker, context
    end
    
    def create_instance( context, result, reference, newinst )
      @trace_file.puts "create_instance ref #{reference}, newinst #{newinst.inspect}"
      RCP_Processor.new reference, newinst
      result.return_objectpath reference
      result.done
      true
    end
    
    def enum_instance_names( context, result, reference )
      @trace_file.puts "enum_instance_names ref #{reference}"
      each(reference) do |ref|
        @trace_file.puts "ref #{ref}"
        result.return_objectpath ref
      end
      result.done
      true
    end
    
    def enum_instances( context, result, reference, properties )
      @trace_file.puts "enum_instances ref #{reference}, props #{properties.inspect}"
      each(reference, properties, true) do |ref|
        @trace_file.puts "ref #{ref}"
        instance = CMPIInstance.new ref
        result.return_instance instance
      end
      result.done
      true
    end
    
    def get_instance( context, result, reference, properties )
      @trace_file.puts "get_instance ref #{reference}, props #{properties.inspect}"
      each(reference, properties, true) do |ref|
        @trace_file.puts "ref #{ref}"
        instance = CMPIInstance.new ref
        result.return_instance instance
        break # only return first instance
      end
      result.done
      true
    end
    
    def set_instance( context, result, reference, newinst, properties )
      @trace_file.puts "set_instance ref #{reference}, newinst #{newinst.inspect}, props #{properties.inspect}"
      properties.each do |prop|
        newinst.send "#{prop.name}=".to_sym, FIXME
      end
      result.return_instance newinst
      result.done
      true
    end
    
    def delete_instance( context, result, reference )
      @trace_file.puts "delete_instance ref #{reference}"
      result.done
      true
    end
    
    # query : String
    # lang : String
    def exec_query( context, result, reference, query, lang )
      @trace_file.puts "exec_query ref #{reference}, query #{query}, lang #{lang}"
      result.done
      true
    end
    
    def cleanup( context, terminating )
      @trace_file.puts "cleanup terminating? #{terminating}"
      true
    end
  end
end
