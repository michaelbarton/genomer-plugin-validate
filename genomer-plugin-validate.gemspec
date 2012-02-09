# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "genomer-plugin-validate/version"

Gem::Specification.new do |s|
  s.name        = "genomer-plugin-validate"
  s.version     = Genomer::Plugin::Validate::VERSION
  s.authors     = ["Michael Barton"]
  s.email       = ["mail@michaelbarton.me.uk"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "genomer-plugin-validate"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "cucumber", "~> 1.1.4"
  s.add_development_dependency "aruba",    "~> 0.4.11"

  # s.add_runtime_dependency "rest-client"
end
