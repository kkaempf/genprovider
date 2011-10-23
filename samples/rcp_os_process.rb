#
# Provider RCP_OSProcess for class RCP_OSProcess:CIM::Class
#
require 'syslog'

require 'cmpi/provider'

module Cmpi
  #
  # Realisation of CIM_OSProcess in Ruby
  #
  #
  # A link between the OperatingSystem and Process(es) running in the
  # context of this OperatingSystem.
  #
  class RCP_OSProcess < AssociationProvider
    
    #
    # Provider initialization
    #
    def initialize( name, broker, context )
      @trace_file = STDERR
      super name, broker, context
    end
    
    def create_instance( context, result, reference, newinst )
      @trace_file.puts "create_instance ref #{reference}, newinst #{newinst.inspect}"
      RCP_OSProcess.new reference, newinst
      result.return_objectpath reference
      result.done
      true
    end
    
    def cleanup( context, terminating )
      @trace_file.puts "cleanup terminating? #{terminating}"
      true
    end
    
    # Associations
    def associator_names( context, result, reference, assoc_class, result_class, role, result_role )
      @trace_file.puts "RCP_OSProcess.associator_names #{context}, #{result}, ref #{reference}, assoc_class #{assoc_class}, result_class #{result_class}, role #{role}, result_role #{result_role}"
    end
    def associators( context, result, reference, assoc_class, result_class, role, result_role, properties )
      @trace_file.puts "RCP_OSProcess.associators #{context}, #{result}, ref #{reference}, assoc_class #{assoc_class}, result_class #{result_class}, role #{role}, result_role #{result_role}, props #{properties}"
    end
    def reference_names( context, result, reference, result_class, role )
      @trace_file.puts "RCP_OSProcess.reference_names ctx #{context}, res #{result}, ref #{reference}, result_class #{result_class}, role #{role}"
    end
    def references( context, result, reference, result_class, role, properties )
      @trace_file.puts "RCP_OSProcess.references #{context}, #{result}, ref #{reference}, result_class #{result_class}, role #{role}, props #{properties}"
    end
    
  end
end
