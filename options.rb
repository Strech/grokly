class Options
  attr_accessor :pattern, :example
  attr_writer :dictionary_path

  def dictionary_path
    @dictionary_path || general_dictionary_path
  end

  def can_compile?
    !@pattern.to_s.strip.empty?
  end

  def can_check?
    !@example.nil? && can_compile?
  end

  private

  def general_dictionary_path
    File.expand_path "../general.grok", __FILE__
  end
end
