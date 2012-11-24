#
# features/support/env.rb
#

require 'rubygems'
require "test/unit"

fdirname = File.dirname(__FILE__)
require File.join(fdirname, "sfcb")

##
# Assuming __FILE__ lives in features/support
#

# establish parent for test data
PARENT = File.expand_path(File.join(fdirname,".."))

# directory with test .mof files
MOFDIR = File.join(PARENT,"mof")

# toplevel directory
TOPLEVEL = File.expand_path(File.join(PARENT,".."))

# use local version for testing
LIBDIR = File.join(TOPLEVEL, "lib")

# genprovider cli binary
GENPROVIDER = File.join(TOPLEVEL,"bin","genprovider")

NAMESPACE = "test/test"

TMPDIR = File.join(TOPLEVEL, "tmp")

$sfcb = Sfcb.new TMPDIR
$sfcb.start
at_exit do
  $sfcb.stop
end
