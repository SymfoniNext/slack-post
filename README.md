Slack-post
----------

Docker image for posting text messages to Slack.

This version uses Consul for storing settings and sends only basic messages.

```
$ export APP_NAME=slack-bot CONSUL="consul:8500"
$ curl -X PUT -d 'Mr. Whale.' "http://$CONSUL/v1/kv/$APP_NAME/username"
$ curl -X PUT -d ':whale:' "http://$CONSUL/v1/kv/$APP_NAME/icon"
$ curl -X PUT -d 'https://slack-hook.url' "http://$CONSUL/v1/kv/$APP_NAME/hook_url"
```

```
$ docker run --rm --network somewhere-with-consul symfoni/slack-post:latest $CONSUL $APP_NAME "hello from slack-post"
```
