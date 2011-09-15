module Fixtures
  def fixture_key(name)
    path = File.join(File.dirname(__FILE__), "../fixtures/keys/#{name}.pub")

    File.read(path)
  end
end
