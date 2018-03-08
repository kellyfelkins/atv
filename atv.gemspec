# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'atv/version'

Gem::Specification.new do |spec|
  spec.name          = "atv"
  spec.version       = Atv::VERSION
  spec.authors       = ["Kelly Felkins"]
  spec.email         = ["kelly@restlater.com"]
  spec.summary       = "Read Ascii Table Values"
  spec.description   = "Read data from an ascii table."
  spec.homepage      = "https://github.com/kellyfelkins/atv"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.11"
end
