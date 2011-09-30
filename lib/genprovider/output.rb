#
# Output - a class to output generated code with indendation
#
module Genprovider
class Output
 private
  def indent
    @file.write( " " * @depth * @indent ) if @newline
  end
 public
  attr_reader :name, :dir
  def initialize file, force=false
    if file.kind_of?(IO)
      @file = file
      @name = nil
    else
      if File.exist?(file) && !force
	STDERR.puts "Not overwriting existing #{file}"
	return
      end
      @file = File.open(file, "w+")
      @name = File.basename file
      @dir = File.expand_path(File.dirname file)
    end
    raise "Cannot create file at #{file}" unless @file
    @newline = true
    @indent = 0
    @wrap = 75 # wrap at this column
    @depth = 2 # indent depth
    yield self if block_given?
  end
  def inc
    @indent += 1
    self
  end
  def dec
    @indent -= 1
    @indent = 0 if @indent < 0
    self
  end
  def write str
    @file.write str
    @newline = false
    self
  end
  def puts str=""
    indent
    @file.puts str
    @newline = true
    self
  end
  def def name, *args
    if args.nil? || args.empty? || args[0].nil?
      self.puts "def #{name}"
    else
      self.puts "def #{name}( #{args.join(', ')} )"
    end
    self.inc
  end
  def end
    self.dec
    self.puts "end"
  end    
  def comment str=nil
    if str =~ /\\n/
      comment $`
      comment $' #'
      return self
    end
    wrap = @wrap - (@depth * @indent + 2)
    if str && str.size > wrap # must wrap
#      puts "#{str.size} > #{wrap}"
      pivot = wrap
      while pivot > 0 && str[pivot] != 32 # search space left of wrap
        pivot -= 1
      end
      if pivot == 0 # no space left of wrap
        pivot = wrap
        while pivot < str.size && str[pivot] != 32 # search space right of wrap
          pivot += 1
        end
      end
      if 0 < pivot && pivot < str.size
#        puts "-wrap @ #{pivot}-"
        comment str[0,pivot]
	comment str[pivot+1..-1]
	return self
      end
    end
    indent
    @file.write "#"
    @file.write " #{str}" if str
    @file.puts
    self
  end
  def printf format, *args
    indent
    Kernel.printf @file, format, *args
    @newline = false
    self
  end
end
end