class Helper
  def self.setup klass, namespace = "test/test"
    client = Sfcc::Cim::Client.connect(:uri => 'http://wsman:secret@localhost:12345', :verify => false)
    raise "Connection error" unless client
    op = Sfcc::Cim::ObjectPath.new(namespace, klass, client)
    return client, op
  end
end