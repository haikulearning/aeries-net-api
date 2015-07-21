# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aeries_net_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'aeries_net_api'
  spec.version       = AeriesNetApi::VERSION

  spec.authors       = %w('Tomas Garrido', 'Mike Gorski')
  spec.email         = %w('tomas.garrido@avantic.net', 'mikeg@haikulearning')
  spec.summary       = 'Allows for connecting to the Aeries.NET API'
  spec.description   = 'Extracts information from Aeries Rest-based API.'

  spec.homepage      = 'https://github.com/haikulearning/aeries-net-api'
  spec.license       = 'Proprietary'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'TODO: Set to http://mygemserver.com'
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless RUBY_VERSION < '1.9'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/|^\.+}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 1.8.6'

  spec.add_runtime_dependency 'faraday', '~>0.8.4'
  spec.add_runtime_dependency 'json' if RUBY_VERSION < '1.9'
  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec',  '~> 3.3'
  spec.add_development_dependency 'rubocop', '~> 0.32'
end
