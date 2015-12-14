MRuby::Gem::Specification.new("grokp") do |spec|
  spec.license = "MIT"
  spec.author  = "Sergey Fedorov"
  spec.summary = "Expand grok parser sentence to regexp and checkit against example"
  spec.bins    = ["grokp"]

  spec.add_dependency "mruby-print", :core => "mruby-print"
  spec.add_dependency "mruby-mtest", :mgem => "mruby-mtest"
end
