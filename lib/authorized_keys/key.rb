require "authorized_keys"

module AuthorizedKeys
  class Key
    attr_accessor :options, :content, :comment

    def initialize(key_string)
      options, self.content, self.comment = *Components.extract(key_string)

      raise "Bad key" unless self.content

      self.options = options.split(/,/)
    end

    def to_s
      options = self.options.join(",") unless self.options.empty?
      [options, content, comment].compact.join(" ")
    end

    def ==(key)
      key = self.class.new(key) if key.is_a?(String)
      content == key.content
    end

  private

    module Components
      OPTIONS = '(.*?)\\s*'
      CONTENT = '(ssh-(?:[dr]sa)\\s.*?)'
      COMMENT = '(?:\\s+(.*))?'

      def self.extract(key_string)
        key_string.scan(/^#{OPTIONS}#{CONTENT}#{COMMENT}$/).flatten.map(&:to_s)
      end
    end
  end
end
