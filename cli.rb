require "optionparser"

class Cli
  def initialize(argv)
    @argv = argv
    @options = Options.new
  end

  # TODO : Refactor run
  # TODO : Add a README
  # TODO : Rebuild as a GEM
  def run
    parser.parse!

    if @options.can_check?
      first_fail = finder.find_first_fail(@options.pattern, @options.example)

      if first_fail.nil?
        puts "\e[0;32mTemplate matched against example successfuly\e[0m"
      else
        puts "\e[0;31mTemplate failed to match an example\e[0m"
        puts "Failed at: \"#{first_fail}\""
        exit 3
      end
    elsif @options.can_compile?
      puts compiler.compile(@options.pattern)
    else
      non_zero_exit(1, message: "Please provide at least --pattern option")
    end
  end

  private

  def non_zero_exit(code, message:)
    puts "\e[0;31m#{message}\e[0m"
    puts "\n"
    puts parser.help
    exit code
  end

  def compiler
    Compiler.new(File.read @options.dictionary_path)
  rescue Errno::ENOENT
    non_zero_exit(2, message: "Unable to open dictionary file at path #{@options.dictionary_path}")
  end

  def finder
    # TODO : Rename to ErrorFinder
    Finder.new(compiler)
  end

  def parser
    @parser ||= OptionParser.new do |o|
      o.banner = "Usage easypeasy [OPTIONS]"

      o.on("-p", "--pattern [PATTERN]", String, "Expand pattern") do |pattern|
        @options.pattern = pattern
      end

      o.on("-e", "--example [TEXT]", String, "Check pattern against example") do |example|
        @options.example = example
      end

      o.on("-d", "--dictionary [PATH]", String, "Path to the dictionary") do |path|
        @options.dictionary_path = path
      end
    end
  end
end
