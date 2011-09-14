require "authorized_keys"

module AuthorizedKeys
  class Key
    attr_accessor :options, :content, :comment

    def initialize(key_string)
      self.options, self.content, self.comment = *Components.extract(key_string)

      raise "Bad key" unless self.content
    end

    def to_s
      [options, content, comment].join(" ")
    end

  private

    module Components
      OPTIONS = '(.*?)\\s*'
      CONTENT = '(ssh-(?:[dr]sa)\\s.*==?)'
      COMMENT = '\\s*(.*)'

      def self.extract(key_string)
        key_string.scan(/^#{OPTIONS}#{CONTENT}#{COMMENT}$/).flatten
      end
    end
  end
end
