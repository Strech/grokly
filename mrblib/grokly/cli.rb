module Grokly
  class Cli
    SHORT_OPTIONS = "d:e:".freeze
    LONG_OPTIONS = %w[version help].map { |x| x.freeze }

    def initialize(argv)
      @options = extract_options(argv)
      @examples = read_examples($stdin)
    end

    def run
      puts "@options = #{@options}"
      puts "@examples = #{@examples}"
    end

    private

    def extract_options(args)
      args.class.send(:include, Getopts)
      args.getopts(SHORT_OPTIONS, LONG_OPTIONS)
    end

    def read_examples(io)
      return [] if IO.select([io], [], [], 0.001).nil?
      io.readlines
    end
  end
end
