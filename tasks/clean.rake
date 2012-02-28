require 'rake/clean'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "features", "support", "sfcb"))
CLEAN.include("**/*~", "Gemfile.lock", "doc", ".yardoc", "pkg", "generated", Sfcb.new.dir)
