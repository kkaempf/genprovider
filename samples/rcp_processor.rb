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
    require File.join(File.dirname(__FILE__), 'rcp_processor')
     
    def self._create(name, broker, context)
      @trace_file.puts "#{self}.create(#{name}, #{broker}, #{context})"
      super broker
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
      RCP_Processor.each(reference) do |ref|
        @trace_file.puts "ref #{ref}"
        result.return_objectpath ref
      end
      result.done
      true
    end
    def enum_instances( context, result, reference, properties )
      @trace_file.puts "enum_instances ref #{reference}, props #{properties.inspect}"
      RCP_Processor.each(reference, properties, true) do |ref|
        @trace_file.puts "ref #{ref}"
        instance = CMPIInstance.new ref
        result.return_instance instance
      end
      result.done
      true
    end
    def get_instance( context, result, reference, properties )
      @trace_file.puts "get_instance ref #{reference}, props #{properties.inspect}"
      RCP_Processor.each(reference, properties, true) do |ref|
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
