if  echo "$TAG_MSG" | egrep -v "Not Found"; then
  #!/bin/sh
  if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
    echo "This is a pull request. No deployment will be done."
    exit 0
  fi

  if [[ "$RELEASE_BETA" != "true" ]]; then
    echo "No deployment required."
    exit 0
  fi

  echo "beta $RELEASE_BETA"

  # Create tag with empty commit to skip ci build
  git checkout $TRAVIS_BRANCH

  if [[ "$RELEASE_BETA" == "true" ]]; then
    git tag -a "v$(echo $BUNDLE_VERSION_STR)-$(echo $BUNDLE_BUILD_NUMBER)" -m "$(echo $TAG_MSG)"
  fi

  git tag -d release
  #git push origin $TRAVIS_BRANCH --follow-tags

  echo "Createing release note file"
  echo -n "$RELEASE_NOTES" > ReleaseNotes.txt
  cat ReleaseNotes.txt

  if [[ "$RELEASE_BETA" = "true" ]]; then
    echo "***************************"
    echo "*      Beta Signing       *"
    echo "***************************"

    PROVISIONING_PROFILE="$HOME/Library/MobileDevice/Provisioning Profiles/RedmartAdHoc.mobileprovision"
    OUTPUTDIR="$PWD/build/Release-iphoneos"

    # To clear release tags
    git push --tags

    # Creat deploy dir if it do not exist
    mkdir -p deploy

    #zip the .app file for s3 deployment
    cp -rf  "$OUTPUTDIR/Mobilizer.app" "./Mobilizer.app"
    zip -r "deploy/Mobilizer-$TRAVIS_BUILD_NUMBER.zip" "./Mobilizer.app"

    xcrun -log -sdk iphoneos PackageApplication "$OUTPUTDIR/Mobilizer.app" -o "$OUTPUTDIR/Mobilizer.ipa" -sign "$DEVELOPER_NAME" -embed "$PROVISIONING_PROFILE"

    zip -r -9 "$OUTPUTDIR/Mobilizer.app.dSYM.zip" "$OUTPUTDIR/Mobilizer.app.dSYM"

    S3_URL="https://s3-ap-southeast-1.amazonaws.com/buildartifacts.redmart.com/mobilizer/mobilizer-ios/builds/Mobilizer-$TRAVIS_BUILD_NUMBER.zip"
    RELEASE_URL=$(curl -s "https://api-ssl.bitly.com/v3/shorten?access_token=$BITLY_OAUTH&longUrl=$(echo $S3_URL)&format=txt")
    RELEASE_META="\nS3 beta download link - $(echo $RELEASE_URL)"
    TAG_MSG="$TAG_MSG $RELEASE_META"

    sleep 5s
  fi

  # Update GitHub with new release
  export data="{\"tag_name\":\"v$(echo $BUNDLE_VERSION_STR)-$(echo $BUNDLE_BUILD_NUMBER)\",\"name\":\"Mobilizer Version $(echo $BUNDLE_VERSION_STR) ($(echo $BUNDLE_BUILD_NUMBER))\",\"target_commitish\":\"$(echo $TRAVIS_BRANCH)\",\"body\":\"$(echo $TAG_MSG)\"}"
  curl -X POST "https://api.github.com/repos/Redmart/mobilizer-ios/releases?access_token=$(echo $GITHUB_OAUTH)" -d "$(echo $data)"
else
	echo "Build passed."
fi
