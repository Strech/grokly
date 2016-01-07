module Grokly
  module Commands
    class Compile
      def initialize(sentence, options = {})
        @sentence = sentence
        @dictionary = options[:dictionary]
      end

      def run
        puts compile
      end

      def compile
        regexp = @sentence.dup

        while /%{.*?}/ === regexp
          regexp.gsub!(/%{.*?}/) do |placeholder|
            # FIXME : Too lazy to check \w+
            word = placeholder.match(/%{(.*?)}/)[1]

            # TODO : Create Logger.debug
            puts "Found '#{placeholder}'"
            puts "Possible rule '#{word}'"
            puts "Found replacement '#{@dictionary[word]}'"

            @dictionary[word] or raise NoWordFoundError, "No rule '#{rule_name}' found in dictionary"
          end
        end

        regexp
      end

      NoWordFoundError = Class.new(RuntimeError)
    end
  end
end
