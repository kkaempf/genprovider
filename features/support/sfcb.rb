#
# Start and stop sfcb for testing
#
require 'tmpdir'
require 'uri'

class Sfcb
  attr_reader :pid, :url, :dir, :stage_dir, :registration_dir, :providers_dir

  def initialize tmpdir = Dir.tmpdir
    @execfile = "/usr/sbin/sfcbd"
    @port = 27163

    File.directory?(tmpdir) || Dir.mkdir(tmpdir)

    @dir = File.join(tmpdir, "genprovider-testing")
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
    
    @cfgfile = File.join(@dir, "sfcb.cfg")
    File.open(@cfgfile, "w+") do |f|
      # create sfcb config file

      {
	"enableHttp" => true,
	"httpPort" => @port,
	"enableHttps" => false,
	"enableSlp" => false,
	"providerTimeoutInterval" => 10,
	"registrationDir" => @registration_dir,
	"localSocketPath" => File.join(@dir, "sfcbLocalSocket"),
	"httpSocketPath" => File.join(@dir, "sfcbHttpSocket"),
	"providerDirs" => "/usr/lib64/sfcb /usr/lib64 /usr/lib64/cmpi #{@providers_dir}"
      }.each do |k,v|
	f.puts "#{k}: #{v}"
      end
    end

    @url = URI::HTTP.build :host => 'localhost', :port => @port
  end

  def start
    raise "Already running" if @pid
    @pid = fork
    if @pid.nil?
      # child
      sfcb_trace_file = File.join($sfcb.dir, "sfcb_trace_file")
      sblim_trace_file = File.join($sfcb.dir, "sblim_trace_file")
      Dir.chdir File.expand_path("..", File.dirname(__FILE__))
      {
#	"SFCB_TRACE_FILE" => sfcb_trace_file,
#        "SFCB_TRACE" => "4",
#        "SBLIM_TRACE_FILE" => sblim_trace_file,
#        "SBLIM_TRACE" => "4",
	"RUBY_PROVIDERS_DIR" => $sfcb.providers_dir
      }.each { |k,v| ENV[k] = v }
      File.delete(sfcb_trace_file) rescue nil
      File.delete(sblim_trace_file) rescue nil
      $stderr.reopen("#{TMPDIR}/sfcbd.err", "w")
      $stdout.reopen("#{TMPDIR}/sfcbd.out", "w")
      Kernel.exec "#{@execfile}", "-c", "#{@cfgfile}"#, "-t", "32768"
    end
    @pid
  end
  
  def stop
    return unless @pid
    Process.kill "QUIT", @pid
    sleep 3
    Process.wait
    @pid = nil
  end
end
