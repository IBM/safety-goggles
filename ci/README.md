# CI


The following commands were used to configure CI with Travis (one-time setup).

```shell
travis env set ART_URL <...>
travis env set ART_USERNAME <...>
travis env set ART_API_KEY <...>
```

Note: If your username has an `@`, change it to `%40`

You can also set these values through the Travis web gui

The value for `notifications/slack/secure` is obtained by running the following
command.

```sh
travis encrypt "<SLACK_TEAM_SUB_DOMAIN>:<SLACK_TOKEN>" --add notifications.slack
```
