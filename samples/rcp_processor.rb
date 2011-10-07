#
# Provider RCP_Processor for class RCP_Processor
#
require 'syslog'

require 'cmpi/provider'

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
	  k.strip!
	  v.strip!
	  if k =~ /processor/
	    yield result if result
	    result = Cmpi::CMPIObjectPath.new reference
	    result[:system_creation_class_name] = "RCP_Processor"
	    result[:system_name] = "Linux" # string
	    result[:creation_class_name] = "RCP_Processor" # string
	    result[:device_id] = v # string
	  end
	  next unless want_instance

#	  result[:instance_id] = 
#	  result[:caption] = nil # string
#	  result[:description] = nil # string
      # result[:element_name] = nil # string
      # result[:generation] = nil # uint64
      # result[:install_date] = nil # datetime
      # result[:name] = nil # string
      # result[:operational_status] = nil # uint16[]
      # result[:status_descriptions] = nil # string[]
      # result[:status] = nil # string
      # result[:health_state] = nil # uint16
      # result[:primary_status] = nil # uint16
      # result[:detailed_status] = nil # uint16
      # result[:operating_status] = nil # uint16
      # result[:communication_status] = nil # uint16
      # result[:enabled_state] = nil # uint16
      # result[:other_enabled_state] = nil # string
      # result[:requested_state] = nil # uint16
      # result[:enabled_default] = nil # uint16
      # result[:time_of_last_state_change] = nil # datetime
      # result[:available_requested_states] = nil # uint16[]
      # result[:transitioning_to_state] = nil # uint16
      # result[:power_management_supported] = nil # bool
      # result[:power_management_capabilities] = nil # uint16[]
      # result[:availability] = nil # uint16
      # result[:status_info] = nil # uint16
      # result[:last_error_code] = nil # uint32
      # result[:error_description] = nil # string
      # result[:error_cleared] = nil # bool
      # result[:other_identifying_info] = nil # string[]
      # result[:power_on_hours] = nil # uint64
      # result[:total_power_on_hours] = nil # uint64
      # result[:identifying_descriptions] = nil # string[]
      # result[:additional_availability] = nil # uint16[]
      # result[:max_quiesce_time] = nil # uint64
      # result[:location_indicator] = nil # uint16
      # result[:role] = nil # string
      # result[:family] = nil # uint16
      # result[:other_family_description] = nil # string
      # result[:upgrade_method] = nil # uint16
      # result[:max_clock_speed] = nil # uint32
      # result[:current_clock_speed] = nil # uint32
      # result[:data_width] = nil # uint16
      # result[:address_width] = nil # uint16
      # result[:load_percentage] = nil # uint16
      # result[:stepping] = nil # string
      # result[:unique_id] = nil # string
      # result[:cpu_status] = nil # uint16
      # result[:external_bus_clock_speed] = nil # uint32
      # result[:characteristics] = nil # uint16[]
      # result[:number_of_enabled_cores] = nil # uint16
      # result[:enabled_processor_characteristics] = nil # uint16[]
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
