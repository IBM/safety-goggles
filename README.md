# Error Handler

This library wraps invocation of Sentry and exception notification for
convenience.

You still need to configure Sentry and ExceptionNotification gems
separately. This gem is for invocation, not configuration.


## Installation

```ruby
source "https://chef.imdemocloud.com:9292/" do
  # Report errors to Sentry
  gem "safety_goggles", "~> 1.1.0"
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

  require "safety_goggles-unauthorized_error"
  raise SafetyGoggles::UnauthorizedError, "HTTP Basic: Access denied." unless success

  success
end
```

## Build as a Gem

*   Geminabox uses Sinatra which conflicts with Rails5 libraries. Install
    `geminabox` on the system but don't include it in the Gemfile.

    ```shell
    gem install geminabox
    ```

*   To run tests:

    ```shell
    bundle exec rspec
    ```

*   To install the gem locally:

    ```shell
    bundle exec rake build && gem install pkg/*.gem --ignore-dependencies
    ```

*   Configure your machine for pushing our gem server:

    ```shell
    gem inabox -c
    ```

    Enter the root url for your personal geminabox instance
    (e.g. <http://gems/>). See
    [credentials](https://w3-connections.ibm.com/wikis/home?lang=en-us#!/wiki/IM%20Demo%20Cloud%20Credentials/page/Credentials)
    for `<PASSWORD>`

    ```shell
    Host: https://admin:<PASSWORD>@chef.imdemocloud.com:9292/
    ```

*   To push the gem to our gem server:

    ```shell
    gem inabox pkg/*.gem
    # https://chef.imdemocloud.com:9292
    ```
