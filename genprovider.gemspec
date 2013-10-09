# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "genprovider/version"

Gem::Specification.new do |s|
  s.name        = "genprovider"
  s.version     = Genprovider::VERSION

  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Klaus Kämpf"]
  s.email       = ["kkaempf@suse.de"]
  s.homepage    = "https://github.com/kkaempf/genprovider"
  s.summary     = %q{A generator for Ruby based CIM providers}
  s.description = %q{Generates Ruby provider templates for use with cmpi-bindings}

  s.requirements << %q{sblim-cmpi-base (for provider-register.sh)}
  s.requirements << %q{sblim-sfcb for testing}

  s.add_dependency("cim", ["~> 1.0"])
  s.add_dependency("mof", ["~> 1.0"])
  s.add_dependency("rdoc")

  s.add_development_dependency('rake')
  s.add_development_dependency('sfcc')
  s.add_development_dependency('bundler')
  s.add_development_dependency('cucumber')
  
  s.rubyforge_project = "genprovider"

  s.files         = `git ls-files`.split("\n")
  s.files.reject! { |fn| fn == '.gitignore' }
  s.extra_rdoc_files    = Dir['README.rdoc', 'CHANGELOG', 'LICENSE']
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
