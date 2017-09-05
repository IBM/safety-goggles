# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "safety_goggles"
  spec.version       = File.open("VERSION", "r").read.strip
  spec.authors       = ["Leons Petrazickis"]
  spec.email         = ["leonsp@ca.ibm.com"]
  spec.summary       = "Rails error handler"
  spec.description   = "Rails error handler that integrates with Sentry and generates 4xx error responses"
  spec.homepage      = "http://cognitiveclass.ai"
  spec.license       = "Nonstandard"

  # TODO: Remove dependency on git.
  spec.files         = %x(git ls-files).split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # Install geminabox on the system but don't include it here
  #  so that Sinatra doesn't conflict with Rails5 stuff

  # Force dependency update
  spec.add_development_dependency "nokogiri", "~> 1.7", ">= 1.7.2"

  # ActionController, ActiveRecord, and ActiveModel error definitions
  spec.add_development_dependency "rails", "~> 5.0", ">= 5.0.2"

  # To install the gem locally:
  # bundle exec rake install
  spec.add_development_dependency "rake", "~> 12.0"

  # Unit tests
  spec.add_development_dependency "rspec", "~> 3.4"

  # Test coverage report
  spec.add_development_dependency "simplecov", ">= 0.11.1"

  # Continuous Integration
  spec.add_development_dependency "travis", "~> 1.8"

  # Automatic Ruby code style checking tool. Aims to enforce the community-driven
  # Ruby Style Guide.
  # https://github.com/bbatsov/rubocop
  spec.add_development_dependency "rubocop", "~> 0.40"

  spec.add_development_dependency "bundler-audit", "~> 0.6"

  # Also send stacktraces
  spec.add_runtime_dependency "sentry-raven", "~> 2.6"
end
