module Grokly
  class Cli
    def initialize(argv)
      @argv = argv
    end

    def run
      p @argv
    end
  end
end
