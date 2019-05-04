#!/bin/bash
set -eox pipefail

if [ -z "$1" ]; then
  echo "Usage: ./build.sh \$VERSION_SHORT"
else
  VERSION_SHORT="$1"
fi

VERSION=$(grep -oP '[0-9]+\.[0-9]+\.[0-9]+' "$VERSION_SHORT/Dockerfile" | head -1)
DOCKER_REPO=factoriotools/docker_factorio_server
cd "$VERSION_SHORT" || exit

if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  if [ "$TRAVIS_BRANCH" == "master" ]; then
    TAG="$VERSION -t $DOCKER_REPO:$VERSION_SHORT"
  else
    TAG="$TRAVIS_BRANCH"
  fi

  if [ -n "$EXTRA_TAG" ]; then
    TAG="$TAG -t $DOCKER_REPO:$EXTRA_TAG"
  fi

  # shellcheck disable=SC2086
  docker build . -t $DOCKER_REPO:$TAG

  # echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
  # docker push "$DOCKER_REPO:$VERSION"
fi

docker images
