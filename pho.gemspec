
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require 'pho/version'

Gem::Specification.new do |s|
  s.name              = "pho"
  s.version           = Pho::VERSION.dup
  s.platform          = Gem::Platform::RUBY
  s.author            = "David Lee"
  s.email             = "dav@davlee.com"
  s.homepage          = "https://github.com/davidlee/pho"
  s.summary           = "CLI utils for photography file management"
  s.description       = "CLI utils for photography file management"
  s.license           = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency('rspec')
  s.add_development_dependency('mocha')
  s.add_development_dependency('rake')
  s.add_development_dependency('activesupport', ">= 3.0.0", "< 5.0")
  s.add_development_dependency('pry')
end
