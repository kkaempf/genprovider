#
# testcase.rb
#

module Genprovider
  class Testcase
    # return Ruby type equivalent
    def rubytype type
      case type.to_sym
      when :boolean then return ""
      when :string then return "String"
      when :char16 then return "Integer"
      when :uint8 then return "Integer"
      when :uint16 then return "Integer"
      when :uint32 then return "Integer"
      when :uint64 then return "Integer"
      when :sint8 then return "Integer"
      when :sint16 then return "Integer"
      when :sint32 then return "Integer"
      when :sint64 then return "Integer"
      when :real32 then return "Float"
      when :real64 then return "Float"
      when :dateTime then return "Time"
      when :reference then return "Sfcc::Cim::ObjectPath"
      when :class then return "Sfcc::Cim::Class"
      else
        STDERR.puts "Unhandled type #{type}"
      end
    end
    
    def initialize c, namespace, out
      out.comment.comment "Testcase for #{namespace}:#{c.name}"
      out.comment.comment "Generated by 'genprovider' for use with cmpi-bindings-ruby"
      out.puts "require 'rubygems'"
      out.puts "require 'sfcc'"
      out.puts "require 'test/unit'"
      out.puts
      out.puts "class Test_#{c.name} < Test::Unit::TestCase"
      out.inc
      out.def "setup"
      out.puts "@client = Sfcc::Cim::Client.connect(:uri => 'https://wsman:secret@localhost:5989', :verify => false)"
      out.puts "@op = Sfcc::Cim::ObjectPath.new('#{namespace}', '#{c.name}')"
      out.end
      out.puts
      out.def "test_registered"
      out.puts "cimclass = @client.get_class(@op)"
      out.puts "assert cimclass"
      out.end
      out.puts
      out.def "test_instance_names"
      out.puts "names = @client.instance_names(@op)"
      out.puts "assert names.size > 0"
      out.puts "names.each do |ref|"
      out.inc
      out.puts "ref.namespace = @op.namespace"
      out.puts "instance = @client.get_instance ref"
      out.puts "assert instance"
      out.puts
      c.features.each do |p|
        next unless p.property?
        out.puts "assert instance.#{p.name}"
        rtype = rubytype p.type
        raise "Unsupported type #{p.type} [#{rtype.class}]" if rtype.nil?
        if rtype.empty?
          out.puts "assert instance.#{p.name}.is_a?(TrueClass) || instance.#{p.name}.is_a?(FalseClass)"
        else
          out.puts "assert_kind_of #{rubytype p.type}, instance.#{p.name} # #{p.type}"
        end
      end
      out.end
      out.end
      out.puts
      out.end # class
    end
  end
end
