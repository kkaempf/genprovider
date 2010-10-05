#
# Start and stop sfcb for testing
#
require 'tempfile'

class Sfcb
  EXECFILE = "/usr/sbin/sfcbd"
  
  attr_reader :pid, :port
  
  def initialize
    @port = 27163
    @cfgfile = Tempfile.new "sfcb"
    @cfgfile.puts "enableHttp:     true"
    @cfgfile.puts "httpPort:       #{port}"
    @cfgfile.puts "enableHttps:    false"
    @cfgfile.close
    @pid = 0
  end
  
  def start
    raise "Already running" unless @pid == 0
    @pid = fork
    if @pid.nil?
      # child
      Dir.chdir File.expand_path("..", File.dirname(__FILE__))
      exec "#{EXECFILE}", "-c", "#{@cfgfile.path}", "-t", "0x200000"
    end
    @pid
  end
  
  def stop
    raise "Not running" if @pid == 0
    Process.kill "QUIT", @pid
    Process.wait
  end
end
