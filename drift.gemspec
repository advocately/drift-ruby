# -*- encoding: utf-8 -*-
require File.expand_path('../lib/drift/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Lachlan Priest']
  gem.email         = ['lachlan@advocate.ly']
  gem.description   = 'A ruby client for the Drift event API.'
  gem.summary       = 'A ruby client for the Drift event API.'
  gem.homepage      = 'https://drift.com'

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'drift'
  gem.require_paths = ['lib']
  gem.version       = Drift::VERSION

  gem.add_dependency('multi_json', '~> 1.0')

  gem.add_development_dependency('rake', '~> 10.5')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('webmock')
  gem.add_development_dependency('addressable', '~> 2.3.6')
  gem.add_development_dependency('json')
end
