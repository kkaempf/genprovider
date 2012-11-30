#
# test/helper.rb
#

require "test/env"

class Helper
  def self.setup klass, namespace = "test/test"
    client = Sfcc::Cim::Client.connect(:uri => $sfcb.uri, :verify => false)
    raise "Connection error" unless client
    op = Sfcc::Cim::ObjectPath.new(namespace, klass, client)
    return client, op
  end
  def self.teardown
#    $sfcb.stop
  end
end

