# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'easy_sms/version'

Gem::Specification.new do |spec|
  spec.name          = "easy-sms"
  spec.version       = EasySMS::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["PavelT"]
  spec.email         = ["paveltyk@gmail.com"]


  spec.summary       = %q{Easy SMS API wrapper}
  spec.description   = %q{Send SMS globally with Easy SMS gem. Ruby API wrapper}
  spec.homepage      = "https://github.com/PavelTyk/easy-sms"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 1.22"

  spec.add_dependency 'rest-client', '1.8.0'
  spec.add_dependency 'json', '1.8.3'
end
