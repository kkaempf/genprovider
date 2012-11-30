#
# features/support/env.rb
#

require 'rubygems'
require "test/unit"

require_relative "../../test/env"

require_relative "./sfcb"

# directory with test .mof files
MOFDIR = File.join(TOPLEVEL,"features","mof")

$sfcb = Sfcb.new :tmpdir => TMPDIR,
                 :provider => "#{TOPLEVEL}/samples/provider"
$sfcb.start
at_exit do
  $sfcb.stop
end
