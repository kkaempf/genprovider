#
# features/support/env.rb
#

require 'rubygems'
require "test/unit"

# establish parent for test data
PARENT = File.expand_path(File.join(File.dirname(__FILE__),".."))

# directory with test .mof files
MOFDIR = File.join(PARENT,"mof")

# toplevel directory
TOPLEVEL = File.expand_path(File.join(PARENT,".."))

# use local version for testing
LIBDIR = File.join(TOPLEVEL, "lib")

# genprovider cli binary
GENPROVIDER = File.join(TOPLEVEL,"bin","genprovider")
