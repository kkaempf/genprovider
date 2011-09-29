task :doc do
  begin
    require 'yard'
    YARD::Rake::YardocTask.new(:doc) do |t|
      t.files   = ['lib/**/*.rb', *extra_docs]
      t.options = ['--no-private']
    end
  rescue LoadError
    STDERR.puts "Install yard if you want prettier docs"
    require 'rdoc/task'
    Rake::RDocTask.new(:doc) do |rdoc|
      rdoc.rdoc_dir = "doc"
      rdoc.title = "dm-bugzilla-adapter #{DataMapper::Adapters::BugzillaAdapter::VERSION}"
      extra_docs.each { |ex| rdoc.rdoc_files.include ex }
    end
  end
end
