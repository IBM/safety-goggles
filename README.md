# Error Handler

This library wraps invocation of Sentry and exception notification for
convenience.

You still need to configure Sentry and ExceptionNotification gems
separately. This gem is for invocation, not configuration.

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
    rake install || gem install pkg/*.gem --ignore-dependencies
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
