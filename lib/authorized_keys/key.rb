require "authorized_keys"

module AuthorizedKeys
  class AuthorizedKeys::BadKeyError < StandardError
    attr_accessor :key

    def initialize(key)
      super("Bad key")
      self.key = key
    end
  end

  class Key
    attr_accessor :options, :type, :content, :comment

    def initialize(key_string)
      options, self.type, self.content, self.comment = *Components.extract(key_string)

      raise BadKeyError.new(key_string) unless self.content

      self.options = options.split(/,/)
    end

    def to_s
      options = self.options.join(",") unless self.options.empty?
      [options, type, content, comment].compact.join(" ")
    end

    def ==(key)
      key = self.class.new(key) if key.is_a?(String)
      content == key.content
    end

  private

    module Components
      OPTIONS = '(.*?)\\s*'
      TYPE = '(ssh-(?:dss|rsa))\\s'
      CONTENT = '(.*?)'
      COMMENT = '(?:\\s+(.*))?'

      def self.extract(key_string)
        key_string.scan(/^#{OPTIONS}#{TYPE}#{CONTENT}#{COMMENT}$/).flatten.map(&:to_s)
      end
    end
  end
end
