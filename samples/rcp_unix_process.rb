#
# Provider RCP_UnixProcess for class RCP_UnixProcess
#
require 'syslog'

require 'cmpi/provider'

module Cmpi
  #
  # Realisation of CIM_UnixProcess in Ruby
  #
  class RCP_UnixProcess < InstanceProvider
    
    private
    #
    # Iterator for names and instances
    #  yields references matching reference and properties
    #
    def each( reference, properties = nil, want_instance = false )
      if want_instance
	result = Cmpi::CMPIObjectPath.new reference.namespace, reference.classname
	result = Cmpi::CMPIInstance.new result
      else
	result = Cmpi::CMPIObjectPath.new reference
      end
      
      # Set key properties
      
      result.CSCreationClassName = nil # string MaxLen 256 (-> CIM_Process)
      result.CSName = nil # string MaxLen 256 (-> CIM_Process)
      result.OSCreationClassName = nil # string MaxLen 256 (-> CIM_Process)
      result.OSName = nil # string MaxLen 256 (-> CIM_Process)
      result.CreationClassName = nil # string MaxLen 256 (-> CIM_Process)
      result.Handle = nil # string MaxLen 256 (-> CIM_Process)
      unless want_instance
        yield result
        return
      end
      
      # Set non-key properties

      # Required !
      result.ParentProcessID = nil # string  (-> CIM_UnixProcess)
      # Required !
      result.RealUserID = nil # uint64  (-> CIM_UnixProcess)
      # Required !
      result.ProcessGroupID = nil # uint64  (-> CIM_UnixProcess)
      # result.ProcessSessionID = nil # uint64  (-> CIM_UnixProcess)
      # result.ProcessTTY = nil # string  (-> CIM_UnixProcess)
      # result.ModulePath = nil # string  (-> CIM_UnixProcess)
      # result.Parameters = [nil] # string[]  (-> CIM_UnixProcess)
      # result.ProcessNiceValue = nil # uint32  (-> CIM_UnixProcess)
      # result.ProcessWaitingForEvent = nil # string  (-> CIM_UnixProcess)
      # result.Name = nil # string  (-> CIM_Process)
      # result.Priority = nil # uint32  (-> CIM_Process)
      # result.ExecutionState = ExecutionState.Unknown # uint16  (-> CIM_Process)
      # result.OtherExecutionDescription = nil # string  (-> CIM_Process)
      # result.CreationDate = nil # dateTime  (-> CIM_Process)
      # result.TerminationDate = nil # dateTime  (-> CIM_Process)
      # result.KernelModeTime = nil # uint64  (-> CIM_Process)
      # result.UserModeTime = nil # uint64  (-> CIM_Process)
      # result.WorkingSetSize = nil # uint64  (-> CIM_Process)
      # result.EnabledState = EnabledState.Unknown # uint16  (-> CIM_EnabledLogicalElement)
      # result.OtherEnabledState = nil # string  (-> CIM_EnabledLogicalElement)
      # result.RequestedState = RequestedState.Unknown # uint16  (-> CIM_EnabledLogicalElement)
      # result.EnabledDefault = EnabledDefault.Enabled # uint16  (-> CIM_EnabledLogicalElement)
      # result.TimeOfLastStateChange = nil # dateTime  (-> CIM_EnabledLogicalElement)
      # result.AvailableRequestedStates = [AvailableRequestedStates.Enabled] # uint16[]  (-> CIM_EnabledLogicalElement)
      # result.TransitioningToState = TransitioningToState.Unknown # uint16  (-> CIM_EnabledLogicalElement)
      # result.InstallDate = nil # dateTime  (-> CIM_ManagedSystemElement)
      # result.OperationalStatus = [OperationalStatus.Unknown] # uint16[]  (-> CIM_ManagedSystemElement)
      # result.StatusDescriptions = [nil] # string[]  (-> CIM_ManagedSystemElement)
      # Deprecated !
      # result.Status = Status.OK # string MaxLen 10 (-> CIM_ManagedSystemElement)
      # result.HealthState = HealthState.Unknown # uint16  (-> CIM_ManagedSystemElement)
      # result.CommunicationStatus = CommunicationStatus.Unknown # uint16  (-> CIM_ManagedSystemElement)
      # result.DetailedStatus = DetailedStatus.send(:"Not Available") # uint16  (-> CIM_ManagedSystemElement)
      # result.OperatingStatus = OperatingStatus.Unknown # uint16  (-> CIM_ManagedSystemElement)
      # result.PrimaryStatus = PrimaryStatus.Unknown # uint16  (-> CIM_ManagedSystemElement)
      # result.InstanceID = nil # string  (-> CIM_ManagedElement)
      # result.Caption = nil # string MaxLen 64 (-> CIM_ManagedElement)
      # result.Description = nil # string  (-> CIM_ManagedElement)
      # result.ElementName = nil # string  (-> CIM_ManagedElement)
      yield result
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
      RCP_UnixProcess.new reference, newinst
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
      each(reference, properties, true) do |instance|
        @trace_file.puts "instance #{instance}"
        result.return_instance instance
      end
      result.done
      true
    end
    
    def get_instance( context, result, reference, properties )
      @trace_file.puts "get_instance ref #{reference}, props #{properties.inspect}"
      each(reference, properties, true) do |instance|
        @trace_file.puts "instance #{instance}"
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
    
    def self.typemap
      {
        "ParentProcessID" => Cmpi::string,
        "RealUserID" => Cmpi::uint64,
        "ProcessGroupID" => Cmpi::uint64,
        "ProcessSessionID" => Cmpi::uint64,
        "ProcessTTY" => Cmpi::string,
        "ModulePath" => Cmpi::string,
        "Parameters" => Cmpi::stringA,
        "ProcessNiceValue" => Cmpi::uint32,
        "ProcessWaitingForEvent" => Cmpi::string,
        "CSCreationClassName" => Cmpi::string,
        "CSName" => Cmpi::string,
        "OSCreationClassName" => Cmpi::string,
        "OSName" => Cmpi::string,
        "CreationClassName" => Cmpi::string,
        "Handle" => Cmpi::string,
        "Name" => Cmpi::string,
        "Priority" => Cmpi::uint32,
        "ExecutionState" => Cmpi::uint16,
        "OtherExecutionDescription" => Cmpi::string,
        "CreationDate" => Cmpi::dateTime,
        "TerminationDate" => Cmpi::dateTime,
        "KernelModeTime" => Cmpi::uint64,
        "UserModeTime" => Cmpi::uint64,
        "WorkingSetSize" => Cmpi::uint64,
        "EnabledState" => Cmpi::uint16,
        "OtherEnabledState" => Cmpi::string,
        "RequestedState" => Cmpi::uint16,
        "EnabledDefault" => Cmpi::uint16,
        "TimeOfLastStateChange" => Cmpi::dateTime,
        "AvailableRequestedStates" => Cmpi::uint16A,
        "TransitioningToState" => Cmpi::uint16,
        "InstallDate" => Cmpi::dateTime,
        "OperationalStatus" => Cmpi::uint16A,
        "StatusDescriptions" => Cmpi::stringA,
        "Status" => Cmpi::string,
        "HealthState" => Cmpi::uint16,
        "CommunicationStatus" => Cmpi::uint16,
        "DetailedStatus" => Cmpi::uint16,
        "OperatingStatus" => Cmpi::uint16,
        "PrimaryStatus" => Cmpi::uint16,
        "InstanceID" => Cmpi::string,
        "Caption" => Cmpi::string,
        "Description" => Cmpi::string,
        "ElementName" => Cmpi::string,
      }
    end
    
    
    class ExecutionState < Cmpi::ValueMap
      def self.map
        {
          "Unknown" => 0,
          "Other" => 1,
          "Ready" => 2,
          "Running" => 3,
          "Blocked" => 4,
          "Suspended Blocked" => 5,
          "Suspended Ready" => 6,
          "Terminated" => 7,
          "Stopped" => 8,
          "Growing" => 9,
          "Ready But Relinquished Processor" => 10,
          "Hung" => 11,
        }
      end
    end
    
    class EnabledState < Cmpi::ValueMap
      def self.map
        {
          "Unknown" => 0,
          "Other" => 1,
          "Enabled" => 2,
          "Disabled" => 3,
          "Shutting Down" => 4,
          "Not Applicable" => 5,
          "Enabled but Offline" => 6,
          "In Test" => 7,
          "Deferred" => 8,
          "Quiesce" => 9,
          "Starting" => 10,
          # "DMTF Reserved" => 11..32767,
          # "Vendor Reserved" => 32768..65535,
        }
      end
    end
    
    class RequestedState < Cmpi::ValueMap
      def self.map
        {
          "Unknown" => 0,
          "Enabled" => 2,
          "Disabled" => 3,
          "Shut Down" => 4,
          "No Change" => 5,
          "Offline" => 6,
          "Test" => 7,
          "Deferred" => 8,
          "Quiesce" => 9,
          "Reboot" => 10,
          "Reset" => 11,
          "Not Applicable" => 12,
          # "DMTF Reserved" => ..,
          # "Vendor Reserved" => 32768..65535,
        }
      end
    end
    
    class EnabledDefault < Cmpi::ValueMap
      def self.map
        {
          "Enabled" => 2,
          "Disabled" => 3,
          "Not Applicable" => 5,
          "Enabled but Offline" => 6,
          "No Default" => 7,
          "Quiesce" => 9,
          # "DMTF Reserved" => ..,
          # "Vendor Reserved" => 32768..65535,
        }
      end
    end
    
    class AvailableRequestedStates < Cmpi::ValueMap
      def self.map
        {
          "Enabled" => 2,
          "Disabled" => 3,
          "Shut Down" => 4,
          "Offline" => 6,
          "Test" => 7,
          "Defer" => 8,
          "Quiesce" => 9,
          "Reboot" => 10,
          "Reset" => 11,
          # "DMTF Reserved" => ..,
        }
      end
    end
    
    class TransitioningToState < Cmpi::ValueMap
      def self.map
        {
          "Unknown" => 0,
          "Enabled" => 2,
          "Disabled" => 3,
          "Shut Down" => 4,
          "No Change" => 5,
          "Offline" => 6,
          "Test" => 7,
          "Defer" => 8,
          "Quiesce" => 9,
          "Reboot" => 10,
          "Reset" => 11,
          "Not Applicable" => 12,
          # "DMTF Reserved" => ..,
        }
      end
    end
    
    class OperationalStatus < Cmpi::ValueMap
      def self.map
        {
          "Unknown" => 0,
          "Other" => 1,
          "OK" => 2,
          "Degraded" => 3,
          "Stressed" => 4,
          "Predictive Failure" => 5,
          "Error" => 6,
          "Non-Recoverable Error" => 7,
          "Starting" => 8,
          "Stopping" => 9,
          "Stopped" => 10,
          "In Service" => 11,
          "No Contact" => 12,
          "Lost Communication" => 13,
          "Aborted" => 14,
          "Dormant" => 15,
          "Supporting Entity in Error" => 16,
          "Completed" => 17,
          "Power Mode" => 18,
          "Relocating" => 19,
          # "DMTF Reserved" => ..,
          # "Vendor Reserved" => 0x8000..,
        }
      end
    end
    
    class Status < Cmpi::ValueMap
      def self.map
        {
          "OK" => :OK,
          "Error" => :Error,
          "Degraded" => :Degraded,
          "Unknown" => :Unknown,
          "Pred Fail" => :"Pred Fail",
          "Starting" => :Starting,
          "Stopping" => :Stopping,
          "Service" => :Service,
          "Stressed" => :Stressed,
          "NonRecover" => :NonRecover,
          "No Contact" => :"No Contact",
          "Lost Comm" => :"Lost Comm",
          "Stopped" => :Stopped,
        }
      end
    end
    
    class HealthState < Cmpi::ValueMap
      def self.map
        {
          "Unknown" => 0,
          "OK" => 5,
          "Degraded/Warning" => 10,
          "Minor failure" => 15,
          "Major failure" => 20,
          "Critical failure" => 25,
          "Non-recoverable error" => 30,
          # "DMTF Reserved" => ..,
          # "Vendor Specific" => 32768..65535,
        }
      end
    end
    
    class CommunicationStatus < Cmpi::ValueMap
      def self.map
        {
          "Unknown" => 0,
          "Not Available" => 1,
          "Communication OK" => 2,
          "Lost Communication" => 3,
          "No Contact" => 4,
          # "DMTF Reserved" => ..,
          # "Vendor Reserved" => 0x8000..,
        }
      end
    end
    
    class DetailedStatus < Cmpi::ValueMap
      def self.map
        {
          "Not Available" => 0,
          "No Additional Information" => 1,
          "Stressed" => 2,
          "Predictive Failure" => 3,
          "Non-Recoverable Error" => 4,
          "Supporting Entity in Error" => 5,
          # "DMTF Reserved" => ..,
          # "Vendor Reserved" => 0x8000..,
        }
      end
    end
    
    class OperatingStatus < Cmpi::ValueMap
      def self.map
        {
          "Unknown" => 0,
          "Not Available" => 1,
          "Servicing" => 2,
          "Starting" => 3,
          "Stopping" => 4,
          "Stopped" => 5,
          "Aborted" => 6,
          "Dormant" => 7,
          "Completed" => 8,
          "Migrating" => 9,
          "Emigrating" => 10,
          "Immigrating" => 11,
          "Snapshotting" => 12,
          "Shutting Down" => 13,
          "In Test" => 14,
          "Transitioning" => 15,
          "In Service" => 16,
          # "DMTF Reserved" => ..,
          # "Vendor Reserved" => 0x8000..,
        }
      end
    end
    
    class PrimaryStatus < Cmpi::ValueMap
      def self.map
        {
          "Unknown" => 0,
          "OK" => 1,
          "Degraded" => 2,
          "Error" => 3,
          # "DMTF Reserved" => ..,
          # "Vendor Reserved" => 0x8000..,
        }
      end
    end
  end
end
