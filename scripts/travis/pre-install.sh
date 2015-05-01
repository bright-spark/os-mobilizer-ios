brew install jq
gem install cocoapods -v '0.34.2'
pod install

export COMMIT_MSG=$(curl -s https://api.github.com/repos/Redmart/mobilizer-ios/git/commits/$TRAVIS_COMMIT?access_token=$GITHUB_OAUTH | jq -r '.message')

export RELEASE_TAG_SHA=$(curl -s https://api.github.com/repos/Redmart/mobilizer-ios/git/refs/tags/release?access_token=$GITHUB_OAUTH | jq -r '.object.sha')

if ! echo "$RELEASE_TAG_SHA" | egrep -q "null"; then
  export TAG_MSG=$(curl -s https://api.github.com/repos/Redmart/mobilizer-ios/git/tags/$RELEASE_TAG_SHA?access_token=$GITHUB_OAUTH | jq -r '.message')
  export RELEASE_BETA=true
  echo "Build for both alpha and beta releases from tag SHA $RELEASE_TAG_SHA"
fi

echo "Release tag message $TAG_MSG"
echo "Travis commit message $COMMIT_MSG"

git config --global user.email "joshua@redmart.com"
git config --global user.name "Travis"
git checkout $TRAVIS_BRANCH
git remote rm origin
git remote add origin https://joshln87:$GITHUB_OAUTH@github.com/Redmart/mobilizer-ios.git

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $TRAVIS_BUILD_NUMBER" "./Mobilizer/Info.plist"

export BUNDLE_BUILD_NUMBER=$TRAVIS_BUILD_NUMBER
echo "Set CFBundleVersion to $BUNDLE_BUILD_NUMBER"

#git add .
#git commit -m "[skip ci] Update build number to $TRAVIS_BUILD_NUMBER for $APP_NAME"

if [[ "$RELEASE_BETA" == "true" ]]; then
  export RELEASE=true
fi

export BUNDLE_VERSION_STR=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "./Mobilizer/Info.plist")
echo "Version $BUNDLE_VERSION_STR ($TRAVIS_BUILD_NUMBER)"
