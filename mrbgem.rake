MRuby::Gem::Specification.new("grokly") do |spec|
  spec.license = "MIT"
  spec.author  = "Sergey Fedorov"
  spec.summary = "Expand grok parser sentence to regexp and checkit against example"
  spec.bins    = ["grokly"]

  spec.add_dependency "mruby-print", core: "mruby-print"
  spec.add_dependency "mruby-regexp-pcre", mgem: "mruby-regexp-pcre"
#  spec.add_dependency "mruby-io", mgem: "mruby-io"
  spec.add_dependency "mruby-getopts", mgem: "mruby-getopts"
  spec.add_dependency "mruby-mtest", mgem: "mruby-mtest"
end
