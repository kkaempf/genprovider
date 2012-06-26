#
# Testcase for root/cimv2:RCP_ArrayDataTypes
#
# Generated by 'genprovider' for use with cmpi-bindings-ruby
require 'rubygems'
require 'sfcc'
require 'test/unit'

class Test_RCP_ArrayDataTypes < Test::Unit::TestCase
  def setup
    @client = Sfcc::Cim::Client.connect(:uri => 'https://wsman:secret@localhost:5989', :verify => false)
    @op = Sfcc::Cim::ObjectPath.new('root/cimv2', 'RCP_ArrayDataTypes')
  end
  
  def test_registered
    cimclass = @client.get_class(@op)
    assert cimclass
  end
  
  def test_instance_names
    names = @client.instance_names(@op)
    assert names.size > 0
    names.each do |ref|
      ref.namespace = @op.namespace
      instance = @client.get_instance ref
      assert instance
      
      assert instance.Name
      if instance.Name
        assert_kind_of String, instance.Name # string
      end
      assert instance.bool
      assert_kind_of Array, instance.bool # boolean[]
      tmp = instance.bool[0]
      if tmp
        assert tmp.is_a?(TrueClass) || tmp.is_a?(FalseClass)
      end
      assert instance.text
      assert_kind_of Array, instance.text # string[]
      tmp = instance.text[0]
      if tmp
        assert_kind_of String, tmp # string[]
      end
      assert instance.char_16
      assert_kind_of Array, instance.char_16 # char16[]
      puts "char16 #{instance.char_16.inspect}"
      tmp = instance.char_16[0]
      if tmp
        assert_kind_of Integer, tmp # char16[]
      end
      assert instance.unsigned_int_8
      assert_kind_of Array, instance.unsigned_int_8 # uint8[]
      tmp = instance.unsigned_int_8[0]
      if tmp
        assert_kind_of Integer, tmp # uint8[]
      end
      assert instance.unsigned_int_16
      assert_kind_of Array, instance.unsigned_int_16 # uint16[]
      tmp = instance.unsigned_int_16[0]
      if tmp
        assert_kind_of Integer, tmp # uint16[]
      end
      assert instance.unsigned_int_32
      assert_kind_of Array, instance.unsigned_int_32 # uint32[]
      tmp = instance.unsigned_int_32[0]
      if tmp
        assert_kind_of Integer, tmp # uint32[]
      end
      assert instance.unsigned_int_64
      assert_kind_of Array, instance.unsigned_int_64 # uint64[]
      tmp = instance.unsigned_int_64[0]
      if tmp
        assert_kind_of Integer, tmp # uint64[]
      end
      assert instance.byte
      assert_kind_of Array, instance.byte # sint8[]
      tmp = instance.byte[0]
      if tmp
        assert_kind_of Integer, tmp # sint8[]
      end
      assert instance.short
      assert_kind_of Array, instance.short # sint16[]
      tmp = instance.short[0]
      if tmp
        assert_kind_of Integer, tmp # sint16[]
      end
      assert instance.int
      assert_kind_of Array, instance.int # sint32[]
      tmp = instance.int[0]
      if tmp
        assert_kind_of Integer, tmp # sint32[]
      end
      assert instance.long
      assert_kind_of Array, instance.long # sint64[]
      tmp = instance.long[0]
      if tmp
        assert_kind_of Integer, tmp # sint64[]
      end
      assert instance.float
      assert_kind_of Array, instance.float # real32[]
      tmp = instance.float[0]
      if tmp
        assert_kind_of Float, tmp # real32[]
      end
      assert instance.double
      assert_kind_of Array, instance.double # real64[]
      tmp = instance.double[0]
      if tmp
        assert_kind_of Float, tmp # real64[]
      end
      assert instance.date_time
      assert_kind_of Array, instance.date_time # dateTime[]
      tmp = instance.date_time[0]
      if tmp
        assert_kind_of Time, tmp # dateTime[]
      end
    end
  end
  
end
