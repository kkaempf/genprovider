#
# Genprovider::Class
#

#
# make element description
#

module Genprovider
  class RDoc
    def description element
      p = element.qualifiers["description", :string]
      return unless p
      p.value.split("\n").each do |l|
	@out.puts l
	@out.puts
      end
    end

    #
    # make feature doc
    #

    def doc_feature feature
      k = feature.key? ? " [Key]" : nil
      @out.puts "== #{feature.name} : #{feature.type.to_s}#{k}"
      description feature
      @out.puts
      vm = feature.qualifiers["valuemap"]
      vs = feature.qualifiers["values"]
      if vm && vs
	@out.puts "* Mapped values"
	vm = vm.value
	vs = vs.value
	loop do
	  m = vm.shift
	  s = vs.shift
	  @out.puts "  * #{m} -> #{s}"
	  break if vm.empty? || vs.empty?
	end
      end
      feature.qualifiers.each do |q|
	n = q.name.downcase
	next if n == "description"
	next if n == "values" || n == "valuemap"
	@out.puts "* #{q}"
      end
      @out.puts

      return unless feature.method?
      args = nil
      feature.parameters.each do |p|
	args ||= []
	if p.qualifiers.include?(:out,:bool)
	  args << "#{p.name.decamelize}_out"
	else
	  args << p.name.decamelize
	end
      end
      n = feature.name.decamelize
      @out.puts "* #{n}(#{args})"
    end
      
    #
    # generate code for property
    #
      
    def doc_property property
      doc_feature property
    end

    #
    # generate code for reference
    #
      
    def doc_reference reference
      doc_feature reference
    end
    
    #
    # generate code for method
    #
    
    def doc_method method
      doc_feature method
    end
    
    #
    # generate provider code for features matching match
    #
    
    def doc_features header, features, match
      features.each do |f|
	next unless f.instance_of? match
	if header
#	  @out.puts header
	  header = nil
	end
	case f
	when CIM::Property then doc_property f
	when CIM::Reference then doc_reference f
	when CIM::Method then doc_method f
	else
	  raise "Unknown feature class #{f.class}"
	end
      end
    end
    
    def doc_class c = nil
      c = @klass unless c
      @out.puts "= #{c.name}"
      description c
      
      if c.superclass
	@out.puts
	@out.puts "=== Superclass: #{c.superclass}"
      end

      doc_features "==Properties", c.features, CIM::Property
      doc_features "==References", c.features, CIM::Reference
      doc_features "==Methods", c.features, CIM::Method
    end
    
    def each_parent
      parent = @klass.parent
      while parent
	yield parent
	parent = parent.parent
      end
    end

    #
    # generate provider code for class 'c'
    #
    
    def initialize c, out
      @klass = c
      @out = out
      @out.puts "= Documentation for #{c.name}"
      each_parent do |k|
	@out.puts "* #{k.name}"
      end
      doc_class
      each_parent do |k|
	doc_class k
      end
    end
  end
end
