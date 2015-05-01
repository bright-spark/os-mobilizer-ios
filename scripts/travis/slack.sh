APP_STR="Mobilizer iOS Build v$(echo $BUNDLE_VERSION_STR).$(echo $BUNDLE_BUILD_NUMBER)"

if $1 == "true"; then 
 STR="$(echo $APP_STR) passed."
else 
 STR="$(echo $APP_STR) failed."
fi;
slackData="payload={\"channel\":\"#mobilizer\",\"username\":\"TRAVIS\",\"text\":\"$(echo $STR)\",\"icon_emoji\":\":rocket:\"}"
curl -X POST "https://redmart.slack.com/services/hooks/incoming-webhook?token=Dz3KtGRQxKLjEa01maX18zBZ" -d "$(echo $slackData)"
