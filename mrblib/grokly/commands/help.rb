module Grokly
  module Commands
    class Help
      def run
        puts "gorkly #{Grokly::VERSION}"
        puts
        puts "Usage:"
        puts
        puts "grokly [option] sentence"
        puts "   -d /path/to/dictionary\t use custom dictionary"
        puts "   -e /path/to/examples\t\t check sentence against examples"
        puts "   --help\t\t\t show this message"
        puts "   --version\t\t\t print grokly version"
      end
    end
  end
end
