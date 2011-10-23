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
    #
    # Calling reference_names for RCP_ComputerSystem calls:
    #   RCP_OSProcess.reference_names ref root/cimv2:RCP_ComputerSystem.CreationClassName="RCP_ComputerSystem",Name="linux-lkbf.site", result_class , role 
    #
    # Calling reference_names for RCP_OperatingSystem calls:
    # RCP_OSProcess.reference_names ref root/cimv2:RCP_OperatingSystem.CreationClassName="RCP_OperatingSystem",CSName="linux-lkbf.site",CSCreationClassName="RCP_ComputerSystem",Name="openSUSE 11.4 (x86_64)", result_class , role 
    
    def reference_names( context, result, reference, result_class, role )
      @trace_file.puts "RCP_OSProcess.reference_names ctx #{context}, res #{result}, ref #{reference}, result_class #{result_class}, role #{role}"
      @trace_file.puts "Called from #{reference.CreationClassName}"

      os_ref = nil # OperatingSystem for result.GroupComponent
      
      # construct reference for upcall
      upref = Cmpi::CMPIObjectPath.new reference.namespace, "RCP_UnixProcess"
      STDERR.puts "upref #{upref}"
      if reference.classname == "RCP_ComputerSystem"
	STDERR.puts "Have CS, need OS"
	upref.CSCreationClassName = reference.classname
	upref.CSName = reference.Name
	os_ref = Cmpi::CMPIObjectPath.new reference.namespace, "RCP_OperatingSystem"
	enum = Cmpi.broker.enumInstanceNames context, os_ref
	os_ref = enum.next_element
      elsif reference.classname == "RCP_OperatingSystem"
	STDERR.puts "Have OS, need nothing"
	upref.OSCreationClassName = reference.classname
      STDERR.puts "upref #{upref}"
	upref.OSName = reference.Name
      STDERR.puts "upref #{upref}"
	os_ref = reference
      else
	result.done
	true
      end
      STDERR.puts "os_ref #{os_ref}"
      STDERR.puts "upref #{upref}"
      enum = Cmpi.broker.enumInstanceNames context, upref
      enum.each do |res|
        os_process = Cmpi::CMPIObjectPath.new reference.namespace, "RCP_OSProcess"
	os_process.GroupComponent = os_ref # CIM_OperatingSystem
	os_process.PartComponent = res # CIM_Process
	@trace_file.puts "RCP_OSProcess.reference_names => #{os_process}"
        result.return_objectpath os_process
      end
      result.done
      true
    end
    def references( context, result, reference, result_class, role, properties )
      @trace_file.puts "RCP_OSProcess.references #{context}, #{result}, ref #{reference}, result_class #{result_class}, role #{role}, props #{properties}"
    end
    
    def self.typemap
      {
        "GroupComponent" => Cmpi::CIM_OperatingSystem,
        "PartComponent" => Cmpi::CIM_Process,
      }
    end
  end
end
