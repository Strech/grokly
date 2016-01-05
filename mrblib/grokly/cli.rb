module Grokly
  class Cli
    SHORT_OPTIONS = "d:e:".freeze
    LONG_OPTIONS = %w[version help].map { |x| x.freeze }

    def initialize(args)
      @options = extract_options(args)
      @sentence = extract_sentence(args)
    end

    def run
      puts "DEBUG"
      puts "@options = #{@options.inspect}"
      puts "@sentence = #{@sentence.inspect}"
      puts "examples = #{examples.inspect}"
      puts "=" * 100

      if version?
        Grokly::Commands::Version.new.run
      elsif test?
        Grokly::Commands::Test.new(sentence, examples: examples, dictionary: dictionary).run
      elsif compile?
        Grokly::Commands::Compile.new(sentence, dictionary: dictionary).run
      else
        Grokly::Commands::Help.new.run
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

    def compile?
      !@sentence.nil? && !@sentence.empty? && !dictionary.empty?
    end

    def version?
      !!@options["version"]
    end

    def test?
      compile? && !examples.empty?
    end

    def dictionary
      []
    end

    def examples
      @examples ||= examples_from_file || examples_from_stdin
    end

    def examples_from_file
      return [] if !@options.key?("e") || @options["e"].empty? || !File.exists?(@options["e"])
      File.open(@options["e"], "r").readlines
    end

    def examples_from_stdin
      return [] if IO.select([$stdin], [], [], 0.001).nil?
      $stdin.readlines
    end
  end
end
