#
# test/helper.rb
#

require "test/env"
require "features/support/sfcb"

class Helper
  def self.setup klass, namespace = "test/test"
    $sfcb = Sfcb.new :tmpdir => TMPDIR,
                 :provider => "#{TOPLEVEL}/samples/provider"
    $sfcb.start
    client = Sfcc::Cim::Client.connect(:uri => 'http://wsman:secret@localhost:12345', :verify => false)
    raise "Connection error" unless client
    op = Sfcc::Cim::ObjectPath.new(namespace, klass, client)
    return client, op
  end
  def self.teardown
    $sfcb.stop
  end
end

