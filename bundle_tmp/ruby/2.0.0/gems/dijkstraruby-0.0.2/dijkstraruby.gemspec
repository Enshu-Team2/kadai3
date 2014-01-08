# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dijkstraruby/version'

Gem::Specification.new do |spec|
  spec.name          = "dijkstraruby"
  spec.version       = Dijkstraruby::VERSION
  spec.authors       = ["Heriberto Perez"]
  spec.email         = ["heriberto.perez@crowdint.com"]
  spec.description   = %q{This gem is an implementation of the dijkstra algorithm}
  spec.summary       = %q{dijkstra algorithm in ruby}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
