class Compiler
  def initialize(dictionary)
    @rules = tokenize(dictionary)
  end

  def compile(pattern)
    regexp = pattern.dup

    while /%{/ === regexp
      regexp.gsub!(/%{.*?}/) do |placeholder|
        rule_name = placeholder.match(/%{(?<rule>\w+)/)[:rule]
        @rules.fetch(rule_name)
      end
    end

    regexp
  end

  private

  def tokenize(dictionary)
    dictionary.split("\n").map(&:chomp)
      .reject { |line| line.empty? || /\A#.*/ === line }
      .map { |line| line.split(" ", 2) }
      .to_h
  end
end
