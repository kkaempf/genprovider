# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "genprovider"

Gem::Specification.new do |s|
  s.name        = "genprovider"
  s.version     = Genprovider::VERSION

  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Klaus Kämpf"]
  s.email       = ["kkaempf@suse.de"]
  s.homepage    = "https://github.com/kkaempf/genprovider"
  s.summary     = %q{A generator for Ruby based CIM providers}
  s.description = %q{Generates Ruby provider templates for use with cmpi-bindings}

  s.add_dependency("cim", ["~> 0.5"])
  s.add_dependency("mof", ["~> 0.3.2"])

  s.add_development_dependency('rake')
  s.add_development_dependency('bundler')
  s.add_development_dependency('cucumber')
  
  s.rubyforge_project = "genprovider"

  s.files         = `git ls-files`.split("\n")
  s.files.reject! { |fn| fn == '.gitignore' }
  s.extra_rdoc_files    = Dir['README*', 'TODO*', 'CHANGELOG*', 'LICENSE']
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
