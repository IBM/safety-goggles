# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
Gem::Specification.new do |spec|
  spec.name          = "safety_goggles"
  spec.version       = ENV.fetch("TRAVIS_TAG", "ci")
  spec.authors       = ["Leons Petrazickis"]
  spec.email         = ["leonsp@ca.ibm.com"]
  spec.summary       = "Rails error handler"
  spec.description   = "Rails error handler that integrates with Sentry and generates 4xx error responses"
  spec.homepage      = "https://github.com/IBM/safety-goggles"
  spec.license       = "MIT"

  # TODO: Remove dependency on git.
  spec.files         = %x(git ls-files).split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # ActionController, ActiveRecord, and ActiveModel error definitions
  spec.add_development_dependency "actionpack", "~> 5.2"
  spec.add_development_dependency "actionview", "~> 5.2", ">= 5.2.2.1"
  spec.add_development_dependency "activemodel", "~> 5.2"
  spec.add_development_dependency "activerecord", "~> 5.2"

  spec.add_development_dependency "bundler-audit", "~> 0.6"

  spec.add_development_dependency "loofah", "~> 2.2", ">= 2.2.3"

  # LDAP errors
  spec.add_development_dependency "net-ldap", "~> 0.16"

  spec.add_development_dependency "nokogiri", "~> 1.10", ">= 1.10.4"

  spec.add_development_dependency "rack", "~> 2.0", ">= 2.0.6"

  spec.add_development_dependency "rails-html-sanitizer", "~> 1.0", ">= 1.0.4"

  # To install the gem locally:
  # bundle exec rake install
  spec.add_development_dependency "rake", "~> 12.0"

  # Unit tests
  spec.add_development_dependency "rspec", "~> 3.4"

  # Test coverage report
  spec.add_development_dependency "simplecov", "~> 0.11", ">= 0.11.1"

  # Continuous Integration
  spec.add_development_dependency "travis", "~> 1.8"

  # Automatic Ruby code style checking tool. Aims to enforce the community-driven
  # Ruby Style Guide.
  # https://github.com/bbatsov/rubocop
  spec.add_development_dependency "rubocop", "~> 0.49"
  spec.add_development_dependency "rubocop-gitlab-security", "~> 0.1"
  spec.add_development_dependency "rubocop-performance", "~> 1.5"
  spec.add_development_dependency "rubocop-rails", "~> 2.3"

  # Also send stacktraces
  spec.add_runtime_dependency "sentry-raven", "~> 2.6"
end
