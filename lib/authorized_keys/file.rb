require "authorized_keys"

module AuthorizedKeys
  class File
    attr_accessor :location
    private       :location=

    def initialize(location=nil)
      self.location = location || "#{ENV['HOME']}/.ssh/authorized_keys"
    end

    def add(key)
      key = Key.new(key) if key.is_a?(String)

      modify do |file|
        file.puts key
      end
    end

  private
    def modify(&block)
      ::File.open(location, 'w', &block)
    end
  end
end
