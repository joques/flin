lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'flin'

Gem::Specification.new do |s|
  s.name = %q{flin}
  s.version = Flin::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = 'iTrinity Inc.  and contributors'
  s.email = ["joque@me.com"]
  s.homepage = "http://github.com/joque/flin"
  s.summary = %q{Bookmark urls and share them across the network}
  s.description = %q{Bookmark urls locally and sync them with a central Tokyo Cabinet key-value store}
  
  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency "cucumber"
  s.add_development_dependency "rspec"
  s.add_dependency(%q<commander>, [">= 4.0.1"])
  s.add_dependency(%q<rufus-tokyo>)

  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables        = ["flin"]    
  s.require_paths      = ["lib"]
end