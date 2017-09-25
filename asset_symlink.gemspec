# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asset_symlink/version'

Gem::Specification.new do |spec|
  spec.name          = "asset_symlink"
  spec.version       = AssetSymlink::VERSION
  spec.authors       = ["Frederick Cheung"]
  spec.email         = ["frederick.cheung@gmail.com"]
  spec.summary       = %q{easily make assets available under a consistent public name}
  spec.description   = %q{easily make assets available under a consistent public name}
  spec.homepage      = "http://github.com/fcheung/asset_symlink"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rails", '>=4', '<=5.1'
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", '< 11.0'
  spec.add_development_dependency "rspec", "~>2.14.0"
end
