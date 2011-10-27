#
# Provider RCP_PhysicalMemory for class RCP_PhysicalMemory:CIM::Class
#
require 'syslog'

require 'cmpi/provider'

module Cmpi
  #
  # Realisation of CIM_PhysicalMemory in Ruby
  #
  #
  # PhysicalMemory is a subclass of CIM_Chip, representing low level memory
  # devices - SIMMS, DIMMs, raw memory chips, etc.
  #
  class RCP_PhysicalMemory < InstanceProvider
    
    #
    # Provider initialization
    #
    def initialize( name, broker, context )
      @trace_file = STDERR
      super name, broker, context
    end
    
    def cleanup( context, terminating )
      @trace_file.puts "cleanup terminating? #{terminating}"
      true
    end
    
    def self.typemap
      {
        "FormFactor" => Cmpi::uint16,
        "MemoryType" => Cmpi::uint16,
        "TotalWidth" => Cmpi::uint16,
        "DataWidth" => Cmpi::uint16,
        "Speed" => Cmpi::uint32,
        "Capacity" => Cmpi::uint64,
        "BankLabel" => Cmpi::string,
        "PositionInRow" => Cmpi::uint32,
        "InterleavePosition" => Cmpi::uint32,
        "RemovalConditions" => Cmpi::uint16,
        "Removable" => Cmpi::boolean,
        "Replaceable" => Cmpi::boolean,
        "HotSwappable" => Cmpi::boolean,
        "Tag" => Cmpi::string,
        "Description" => Cmpi::string,
        "CreationClassName" => Cmpi::string,
        "ElementName" => Cmpi::string,
        "Manufacturer" => Cmpi::string,
        "Model" => Cmpi::string,
        "SKU" => Cmpi::string,
        "SerialNumber" => Cmpi::string,
        "Version" => Cmpi::string,
        "PartNumber" => Cmpi::string,
        "OtherIdentifyingInfo" => Cmpi::string,
        "PoweredOn" => Cmpi::boolean,
        "ManufactureDate" => Cmpi::dateTime,
        "VendorEquipmentType" => Cmpi::string,
        "UserTracking" => Cmpi::string,
        "CanBeFRUed" => Cmpi::boolean,
        "InstallDate" => Cmpi::dateTime,
        "Name" => Cmpi::string,
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
      }
    end
    
    private
    #
    # Iterator for names and instances
    #  yields references matching reference and properties
    #
    def each( context, reference, properties = nil, want_instance = false )
      dmi = {}
      IO.popen("dmidecode -t memory") do |f|
	k = nil
	while l = f.gets
	  if l =~ /^\s*([^:]+):\s*(.*)\s*$/
	    if $1
	      k = $1
	      if $2.empty?
		dmi[k] = []
	      else
		dmi[k] = $2.strip
	      end
	    end
	  elsif k
	    dmi[k] << l.strip
	  end
	end
      end
      @trace_file.puts "dmi #{dmi.inspect}"
      
      device_id = reference.DeviceID rescue nil
      if want_instance
        result = Cmpi::CMPIObjectPath.new reference.namespace, "RCP_PhysicalMemory"
        result = Cmpi::CMPIInstance.new result
      else
        result = Cmpi::CMPIObjectPath.new reference.namespace, "RCP_PhysicalMemory"
      end
      
      # Set key properties
      
      result.Tag = nil # string MaxLen 256  (-> CIM_PhysicalElement)
      result.CreationClassName = nil # string MaxLen 256  (-> CIM_PhysicalElement)
      unless want_instance
        yield result
        return
      end
      
      # Instance: Set non-key properties
      
      # result.FormFactor = FormFactor.Unknown # uint16  (-> CIM_PhysicalMemory)
      # result.MemoryType = MemoryType.Unknown # uint16  (-> CIM_PhysicalMemory)
      # result.TotalWidth = nil # uint16  (-> CIM_PhysicalMemory)
      # result.DataWidth = nil # uint16  (-> CIM_PhysicalMemory)
      # result.Speed = nil # uint32  (-> CIM_PhysicalMemory)
      # result.Capacity = nil # uint64  (-> CIM_PhysicalMemory)
      # result.BankLabel = nil # string MaxLen 64  (-> CIM_PhysicalMemory)
      # result.PositionInRow = nil # uint32  (-> CIM_PhysicalMemory)
      # result.InterleavePosition = nil # uint32  (-> CIM_PhysicalMemory)
      # result.RemovalConditions = RemovalConditions.Unknown # uint16  (-> CIM_PhysicalComponent)
      # Deprecated !
      # result.Removable = nil # boolean  (-> CIM_PhysicalComponent)
      # Deprecated !
      # result.Replaceable = nil # boolean  (-> CIM_PhysicalComponent)
      # Deprecated !
      # result.HotSwappable = nil # boolean  (-> CIM_PhysicalComponent)
      # result.Description = nil # string  (-> CIM_PhysicalElement)
      # result.ElementName = nil # string  (-> CIM_PhysicalElement)
      # result.Manufacturer = nil # string MaxLen 256  (-> CIM_PhysicalElement)
      # result.Model = nil # string MaxLen 256  (-> CIM_PhysicalElement)
      # result.SKU = nil # string MaxLen 64  (-> CIM_PhysicalElement)
      # result.SerialNumber = nil # string MaxLen 256  (-> CIM_PhysicalElement)
      # result.Version = nil # string MaxLen 64  (-> CIM_PhysicalElement)
      # result.PartNumber = nil # string MaxLen 256  (-> CIM_PhysicalElement)
      # result.OtherIdentifyingInfo = nil # string  (-> CIM_PhysicalElement)
      # result.PoweredOn = nil # boolean  (-> CIM_PhysicalElement)
      # result.ManufactureDate = nil # dateTime  (-> CIM_PhysicalElement)
      # result.VendorEquipmentType = nil # string  (-> CIM_PhysicalElement)
      # result.UserTracking = nil # string  (-> CIM_PhysicalElement)
      # result.CanBeFRUed = nil # boolean  (-> CIM_PhysicalElement)
      # result.InstallDate = nil # dateTime  (-> CIM_ManagedSystemElement)
      # result.Name = nil # string MaxLen 1024  (-> CIM_ManagedSystemElement)
      # result.OperationalStatus = [OperationalStatus.Unknown] # uint16[]  (-> CIM_ManagedSystemElement)
      # result.StatusDescriptions = [nil] # string[]  (-> CIM_ManagedSystemElement)
      # Deprecated !
      # result.Status = Status.OK # string MaxLen 10  (-> CIM_ManagedSystemElement)
      # result.HealthState = HealthState.Unknown # uint16  (-> CIM_ManagedSystemElement)
      # result.CommunicationStatus = CommunicationStatus.Unknown # uint16  (-> CIM_ManagedSystemElement)
      # result.DetailedStatus = DetailedStatus.send(:"Not Available") # uint16  (-> CIM_ManagedSystemElement)
      # result.OperatingStatus = OperatingStatus.Unknown # uint16  (-> CIM_ManagedSystemElement)
      # result.PrimaryStatus = PrimaryStatus.Unknown # uint16  (-> CIM_ManagedSystemElement)
      # result.InstanceID = nil # string  (-> CIM_ManagedElement)
      # result.Caption = nil # string MaxLen 64  (-> CIM_ManagedElement)
      yield result
    end
    public
    
    def create_instance( context, result, reference, newinst )
      @trace_file.puts "create_instance ref #{reference}, newinst #{newinst.inspect}"
      # Create instance according to reference and newinst
      result.return_objectpath reference
      result.done
      true
    end
    
    def enum_instance_names( context, result, reference )
      @trace_file.puts "enum_instance_names ref #{reference}"
      each(context, reference) do |ref|
        @trace_file.puts "ref #{ref}"
        result.return_objectpath ref
      end
      result.done
      true
    end
    
    def enum_instances( context, result, reference, properties )
      @trace_file.puts "enum_instances ref #{reference}, props #{properties.inspect}"
      each(context, reference, properties, true) do |instance|
        @trace_file.puts "instance #{instance}"
        result.return_instance instance
      end
      result.done
      true
    end
    
    def get_instance( context, result, reference, properties )
      @trace_file.puts "get_instance ref #{reference}, props #{properties.inspect}"
      each(context, reference, properties, true) do |instance|
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
    
    #
    # ----------------- valuemaps following, don't touch -----------------
    #
    
    class FormFactor < Cmpi::ValueMap
      def self.map
        {
          "Unknown" => 0,
          "Other" => 1,
          "SIP" => 2,
          "DIP" => 3,
          "ZIP" => 4,
          "SOJ" => 5,
          "Proprietary" => 6,
          "SIMM" => 7,
          "DIMM" => 8,
          "TSOP" => 9,
          "PGA" => 10,
          "RIMM" => 11,
          "SODIMM" => 12,
          "SRIMM" => 13,
          "SMD" => 14,
          "SSMP" => 15,
          "QFP" => 16,
          "TQFP" => 17,
          "SOIC" => 18,
          "LCC" => 19,
          "PLCC" => 20,
          "BGA" => 21,
          "FPBGA" => 22,
          "LGA" => 23,
        }
      end
    end
    
    class MemoryType < Cmpi::ValueMap
      def self.map
        {
          "Unknown" => 0,
          "Other" => 1,
          "DRAM" => 2,
          "Synchronous DRAM" => 3,
          "Cache DRAM" => 4,
          "EDO" => 5,
          "EDRAM" => 6,
          "VRAM" => 7,
          "SRAM" => 8,
          "RAM" => 9,
          "ROM" => 10,
          "Flash" => 11,
          "EEPROM" => 12,
          "FEPROM" => 13,
          "EPROM" => 14,
          "CDRAM" => 15,
          "3DRAM" => 16,
          "SDRAM" => 17,
          "SGRAM" => 18,
          "RDRAM" => 19,
          "DDR" => 20,
          "DDR-2" => 21,
          "BRAM" => 22,
          "FB-DIMM" => 23,
          "DDR3" => 24,
          "FBD2" => 25,
          # "DMTF Reserved" => 26..32567,
          # "Vendor Reserved" => 32568..65535,
        }
      end
    end
    
    class RemovalConditions < Cmpi::ValueMap
      def self.map
        {
          "Unknown" => 0,
          "Not Applicable" => 2,
          "Removable when off" => 3,
          "Removable when on or off" => 4,
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
