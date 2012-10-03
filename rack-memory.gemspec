# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/leakin/version'

Gem::Specification.new do |gem|
  gem.name          = 'rack-leakin'
  gem.version       = Rack::Leakin::VERSION
  gem.authors       = ['Dimko']
  gem.email         = ['deemox@gmail.com']
  gem.description   = %q{Rack middleware that detect and handle memory leaks}
  gem.summary       = %q{Rack middleware that detect and handle memory leaks}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'rack'
  gem.add_dependency 'process_memory'
end
