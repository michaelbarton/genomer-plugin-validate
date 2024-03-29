# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "genomer-plugin-validate"
  s.version     = File.read('VERSION')
  s.authors     = ["Michael Barton"]
  s.email       = ["mail@michaelbarton.me.uk"]
  s.homepage    = ""
  s.summary     = %q{Validate assembly files for errors}
  s.description = %q{Test assembly files for common errors which may lead to incorrect assembly}

  s.rubyforge_project = "genomer-plugin-validate"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "genomer",          ">= 0.0.6"
  s.add_runtime_dependency "heredoc_unindent", "~> 1.1.0"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec",                   "~> 2.8.0"
  s.add_development_dependency "scaffolder-test-helpers", "~> 0.4.1"
  s.add_development_dependency "cucumber",                "~> 1.1.4"
  s.add_development_dependency "aruba",                   "~> 0.4.11"
  s.add_development_dependency "rr",                      "~> 1.0.4"
end
