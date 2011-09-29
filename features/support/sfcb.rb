#
# Start and stop sfcb for testing
#
require 'tempfile'
require 'uri'

class Sfcb
  attr_reader :pid, :url, :dir, :stage_dir, :registration_dir, :providers_dir

  def initialize
    @execfile = "/usr/sbin/sfcbd"
    @port = 27163

    @cfgfile = Tempfile.new "sfcb"
    @dir = File.join(File.dirname(@cfgfile.path), "genprovider-testing")
    Dir.mkdir @dir rescue nil
    STDERR.puts "Sfcb directory at #{@dir}"

    @stage_dir = File.join(dir, "stage")
    Dir.mkdir @stage_dir rescue nil
    File.symlink("/var/lib/sfcb/stage/default.reg", File.join(@stage_dir, "default.reg")) rescue nil
    @mofs_dir = File.join(@stage_dir, "mofs")
    Dir.mkdir @mofs_dir rescue nil
    
    @registration_dir = File.join(dir, "registration")
    Dir.mkdir @registration_dir rescue nil

    @providers_dir = File.join(dir, 'providers')
    Dir.mkdir @providers_dir rescue nil

    Kernel.system "sfcbrepos", "-s", @stage_dir, "-r", @registration_dir, "-f"
    # create sfcb config file

    {
      "enableHttp" => true,
      "httpPort" => @port,
      "enableHttps" => false,
      "registrationDir" => @registration_dir,
      "localSocketPath" => File.join(@dir, "sfcbLocalSocket"),
      "httpSocketPath" => File.join(@dir, "sfcbHttpSocket"),
      "providerDirs" => "/usr/lib64/sfcb /usr/lib64 /usr/lib64/cmpi #{@providers_dir}"
    }.each do |k,v|
      @cfgfile.puts "#{k}: #{v}"
    end
    @cfgfile.close

    @url = URI::HTTP.build :host => 'localhost', :port => @port
    @pid = 0
  end

  def start
    raise "Already running" unless @pid == 0
    @pid = fork
    if @pid.nil?
      # child
      Dir.chdir File.expand_path("..", File.dirname(__FILE__))
      exec "#{@execfile}", "-c", "#{@cfgfile.path}", "-t", "0x200000"
    end
    @pid
  end
  
  def stop
    raise "Not running" if @pid == 0
    Process.kill "QUIT", @pid
    Process.wait
  end
end
