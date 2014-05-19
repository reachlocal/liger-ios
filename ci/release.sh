#/bin/bash
set -e

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

# Push to github
echo git tag $tag
echo git push origin --tags

# Release podspec to cocoapods
echo pod push master LigerMobile.podspec --verbose

echo "Release successful!"
