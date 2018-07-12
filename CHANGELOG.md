# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased][]

## [2.1.0][] - 2018-07-12

### Added

- Added support for `Net::LDAP::Error` as a 422.

## [2.0.10][] - 2017-09-05

### Changed

- Removed ExceptionNotifier integration; just use Sentry
- Renamed `dswb-error_handler` to `safety_goggles`
- Renamed `Dswb:ErrorHandler` to `SafetyGoggles::Handler`
- Integrated with Travis CI and Artifactory
- Updated Ruby from `2.3.1` to `2.3.4`
- Only require relevant parts of Rails

## [1.2.2][] - 2017-04-27

### Changed

- Handle `ActiveRecord::RecordNotUnique` as a 422

### Fixed

- Swap RecordNotFound and Unauthorized error definitions

## 1.1.0 - 2017-03-09

### Changed

- More resilience
- Handle `Dswb::RecordNotFoundError` as a 404

# 1.0.6

### Changed

- Removed runtime dependency on Rails

# 1.0.3

### Changed

- SecurityError is a 403

# 1.0.1

### Changed

- Fix for environment check

[unreleased]: https://github.ibm.com/cognitive-class-labs/safety_goggles/compare/2.1.0...HEAD
[2.1.0]: https://github.ibm.com/cognitive-class-labs/safety_goggles/compare/2.0.10...2.1.0
[2.0.10]: https://github.ibm.com/cognitive-class-labs/safety_goggles/compare/v1.2.2...2.0.10
[1.2.2]: https://github.ibm.com/cognitive-class-labs/safety_goggles/compare/v1.1.0...v1.2.2
