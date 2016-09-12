#!/bin/bash

function usage() {
  echo "Usage:"
  echo "./slack.sh <consul-addr> <key-name> <text-message>"
  echo "./slack.sh localhost:8500 slack-bot \"hello from slack bot\""
  exit 1
}

consul=$1
if [[ -z "$consul" ]]; then
  usage;
fi

shift
keyname=$1
if [[ -z "$keyname" ]]; then
  usage;
fi

shift
text=$1
if [[ -z "$text" ]]; then
  usage;
fi

# Get something from consul
declare -A config
for v in $(curl -s "http://$consul/v1/kv/$keyname?recurse=1" | jq -r "map(\"\(.Key):\(.Value)\") | .[] | ltrimstr(\"$keyname/\")"); do
  config[${v%:*}]=$(base64 -d < <(echo "${v#*:}"))
done


# Send something to slack
# More adventurous stuff [probably] coming later
payload="{\"username\":\"${config['username']}\", \"icon_emoji\": \"${config['icon']}\",\"text\": \"$text\"}"
curl -s -X POST --data-urlencode "payload=$payload" "${config['hook_url']}"
