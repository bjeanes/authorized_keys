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

    def remove(key)
      key = Key.new(key) if key.is_a?(String)

      ::File.open(location, 'r') do |file|
        ::File.unlink(location)

        ::File.open(location, 'w') do |new_file|
          file.each do |line|
            new_file.puts line unless key == Key.new(line)
            new_file.flush
          end
        end
      end
    end

  private
    def modify(&block)
      ::File.open(location, 'a+', &block)
    end
  end
end
