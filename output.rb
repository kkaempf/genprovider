#
# Output - a class to output generated code with indendation
#
class Output
 private
  def indent
    @file.write " " * @depth * @indent
  end
 public
  attr_reader :name, :dir
  def initialize file
    if file.kind_of?(IO)
      @file = file
      @name = nil
    else
      @file = File.open(file, "w+")
      @name = File.basename file
      @dir = File.expand_path(File.dirname file)
    end
    raise "Cannot create file at #{file}" unless @file
    @indent = 0
    @wrap = 75 # wrap at this column
    @depth = 2 # indent depth
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
    self
  end
  def puts str=""
    indent
    @file.puts str
    self
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
    self
  end
end
