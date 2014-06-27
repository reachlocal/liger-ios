#/bin/bash
set -e

# Install our gems
bundle

# Silly character-replacement hack to compensate for poor Travis character support
echo $podnetrc | tr '^' ' ' | tr '~' '\n' > ~/.netrc
chmod 0600 ~/.netrc

# Confirm pod session (removing listed IP addresses)
# This should expose any pod failures earlier in dev cycle than a release...
pod trunk me | sed 's/ IP.*//'

# Abort checks
if [ "$TRAVIS" != "true" ]; then
	echo "Fatal: not running in Travis. Aborting."
	exit 1
fi

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
	echo "Travis thinks this is a pull request; no release."
	exit 0
fi

if [ "$TRAVIS_BRANCH" != "stable" ]; then
	echo "Commit is not to a release branch; no release."
	exit 0
fi

echo "Releasing a new version of liger-ios."

# Parse podspec to get version, verify semver
tag=`./ci/getVersion.rb`
re='^[v0-9]+\.[0-9]+\.[0-9]+$'
if ! [[ $tag =~ $re ]] ; then
   echo "error: Not a number" >&2; exit 1
fi

# Debug output
git remote -v
git status
git log --decorate --graph -n 3

# Add github deploy key
chmod 600 .travis/deploy_key.pem
ssh-add .travis/deploy_key.pem

# Push to github
git tag $tag
git push origin --tags

# Release podspec to cocoapods
pod trunk push LigerMobile.podspec --verbose

"Release successful!"
