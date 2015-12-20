module Grokly
  module Commands
    class Version
      def run
        puts "gorkly #{Grokly::VERSION}"
      end
    end
  end
end
