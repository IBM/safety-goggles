# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased

## 2.0.11
### Fixed
-   Fixed requires for code that just does `require "safety_goggles"`

## 2.0.10
### Changed
-   Removed ExceptionNotifier integration; just use Sentry
-   Renamed `dswb-error_handler` to `safety_goggles`
-   Renamed `Dswb:ErrorHandler` to `SafetyGoggles::Handler`
-   Integrated with Travis CI and Artifactory
-   Updated Ruby from `2.3.1` to `2.3.4`
-   Only require relevant parts of Rails

## 1.2.2
### Changed
*   Handle `ActiveRecord::RecordNotUnique` as a 422

### Fixed
*   Swap RecordNotFound and Unauthorized error definitions

## 1.1.0
### Changed
*   More resilience
*   Handle `Dswb::RecordNotFoundError` as a 404

# 1.0.6
### Changed
*   Removed runtime dependency on Rails

# 1.0.3
### Changed
*   SecurityError is a 403

# 1.0.1
### Changed
*   Fix for environment check
