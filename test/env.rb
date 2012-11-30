#
# test/env.rb
#

fdirname = File.dirname(__FILE__)

##
# Assuming __FILE__ lives in test/
#

# establish parent for test data
TOPLEVEL = File.expand_path(File.join(fdirname,".."))

# use local version for testing
LIBDIR = File.join(TOPLEVEL, "lib")

# genprovider cli binary
GENPROVIDER = File.join(TOPLEVEL,"bin","genprovider")

NAMESPACE = "test/test"

TMPDIR = File.join(TOPLEVEL, "tmp")

