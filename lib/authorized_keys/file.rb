require "authorized_keys"

module AuthorizedKeys
  class File
    attr_accessor :location
    private       :location=

    def initialize(location=nil)
      self.location = location || "#{ENV['HOME']}/.ssh/authorized_keys"
    end
  end
end
