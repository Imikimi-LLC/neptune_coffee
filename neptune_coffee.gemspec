# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'neptune_coffee/version'

Gem::Specification.new do |spec|
  spec.name          = "neptune_coffee"
  spec.version       = NeptuneCoffee::VERSION
  spec.authors       = ["Shane Brinkman-Davis"]
  spec.email         = ["shanebdavis@gmail.com"]
  spec.description   = %q{opinionated javascript-AMD-module generator}
  spec.summary       = %q{NeptuneCoffee is an opinionated module generator. Modules and namespaces are automatically generated based on the project's directory names and structure.}
  spec.homepage      = "https://github.com/Imikimi-LLC/neptune_coffee"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "trollop"
  spec.add_dependency "extlib"  # for camel_case
  spec.add_dependency "coderay"
  spec.add_dependency "guard"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 2.14.0'
end
