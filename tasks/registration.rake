task :registration => [:sfcb] do |t|
  puts "Register all providers"
  
  require_relative "../test/registration"
  Dir['samples/registration/*.registration'].each do |regname|
    klass = File.basename regname, ".mof"
    register :klass => klass
  end
end
