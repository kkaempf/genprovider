#
# features/support/env.rb
#

require 'rubygems'
require "test/unit"

PARENT = File.expand_path(File.join(File.dirname(__FILE__),".."))
TOPLEVEL = File.expand_path(File.join(PARENT,"..",".."))
GENPROVIDER = File.join(TOPLEVEL,"genprovider.rb")
MOFDIR = File.join(PARENT,"mof")
