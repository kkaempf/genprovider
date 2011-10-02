#
# Provider RCP_ProcessorProvider for class RCP_Processor
#
require 'syslog'

require 'cmpi/provider'

module Cmpi
  #
  # Realisation of CIM_Processor in Ruby
  #
  class RCP_ProcessorProvider < InstanceProvider
    require File.join(File.dirname(__FILE__), 'rcp_processor')
    
    
    def initialize broker
      @trace_file = STDERR
      if ENV['SBLIM_TRACE']
        f = ENV['SBLIM_TRACE_FILE']
        if f
          @trace_file = File.open f, 'a+'
          raise "Cannot open SBLIM_TRACE_FILE #{f}" unless @trace_file
        end
      end
      @trace_file.puts "Initializing #{self}"
      super broker
    end
    def enum_instance_names( context, result, reference )
      @trace_file.puts "enum_instance_names ref #{reference}"
      RCP_Processor.each_name(reference) do |ref|
        @trace_file.puts "ref #{ref}"
        result.return_objectpath ref
      end
      result.done
      true
    end
    def enum_instances( context, result, reference, properties )
      @trace_file.puts "enum_instances ref #{reference}, props #{properties.inspect}"
      RCP_Processor.each(reference,properties) do |ref|
        @trace_file.puts "ref #{ref}"
        instance = CMPIInstance.new ref
        result.return_instance instance
      end
      result.done
      true
    end
    def get_instance( context, result, reference, properties )
      @trace_file.puts "get_instance ref #{reference}, props #{properties.inspect}"
      RCP_Processor.each(reference,properties) do |ref|
        @trace_file.puts "get_instance ref #{ref}"
        instance = CMPIInstance.new ref
        @trace_file.puts "get_instance instance #{instance}"
        result.return_instance instance
        break # only return first instance
      end
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
