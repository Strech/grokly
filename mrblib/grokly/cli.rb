module Grokly
  class Cli
    SHORT_OPTIONS = "d:e:".freeze
    LONG_OPTIONS = %w[version help].map { |x| x.freeze }

    def initialize(args)
      @options = extract_options(args)
      @sentence = extract_sentence(args)
    end

    def run
      #puts "@options = #{@options.inspect}"
      #puts "@sentence = #{@sentence.inspect}"

      if help?
        Grokly::Commands::Help.new.run
      elsif compile_and_test?
        Grokly::Commands::Test.new(sentence, examples: examples, dictionary: dictionary).run
      elsif compile?
        Grokly::Commands::Compile.new(sentence, dictionary: dictionary).run
      end
    end

    private

    def extract_options(args)
      args.class.send(:include, Getopts)
      args.getopts(SHORT_OPTIONS, *LONG_OPTIONS)
    end

    def extract_sentence(args)
      args.last if /\A[^\-]/ =~ args.last
    end

    def help?
      !!@options["?"] || !!@options["help"] || @sentence.nil?
    end

    def compile?
    end

    def compile_and_test?
    end

    def dictionary
    end

    def examples
      IO.select([$stdin], [], [], 0.001).nil?
      $stdin.readlines
    end
  end
end
