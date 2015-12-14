class Finder
  def initialize(compiler)
    @compiler = compiler
  end

  def find_first_fail(pattern, example)
    pattern.split(" ").each_with_object("") do |part, memo|
      memo << " " unless memo.empty?
      memo << part
      regexp = @compiler.compile(memo)

      return memo if example.match(regexp).nil?
    end

    nil
  end
end
