# Error Handler

This library wraps invocation of Sentry and exception notification for
convenience.

You still need to configure Sentry and ExceptionNotification gems
separately. This gem is for invocation, not configuration.


## Installation

```ruby
source "https://na.artifactory.swg-devops.com/artifactory/api/gems/apset-ruby" do
  # Report errors to Sentry
  gem "safety_goggles", "~> 2.0"
end
```

## Sample Usage

In a controller such as `application_controller.rb`:

```ruby
rescue_from Exception, with: :render_error

def render_error(error)
  require "safety_goggles"
  code = SafetyGoggles::Handler.handle_error(error)

  render status: code, json: { code: code, message: error.to_s }
end
```

If you'd like to configure HTTP Basic Auth to throw exceptions and trigger
the above code path, you can do this in the controller:

```ruby
include ActionController::HttpAuthentication::Basic::ControllerMethods

MY_USERNAME = ENV.fetch("MY_USERNAME")
MY_PASSWORD = ENV.fetch("MY_PASSWORD")

before_action do
  success = authenticate_with_http_basic do |name, password|
    # This comparison uses & so that it doesn't short circuit and
    # uses `variable_size_secure_compare` so that length information
    # isn't leaked.
    ActiveSupport::SecurityUtils.variable_size_secure_compare(name, MY_USERNAME) &
      ActiveSupport::SecurityUtils.variable_size_secure_compare(password, MY_PASSWORD)
  end

  require "safety_goggles/unauthorized_error"
  raise SafetyGoggles::UnauthorizedError, "HTTP Basic: Access denied." unless success

  success
end
```

## Build as a Gem

-   Travis CI will build and publish a new version of the gem 
    whenever you push a new tag:
    
    ```
    git tag -a 2.0.0 -m v2.0.0 && git push --tags
    ```

-   Should the need arise, you can install a local version as
    follows:
    
    ``` 
    gem build *.gemspec
    gem install *.gem --ignore-dependencies
    ```
