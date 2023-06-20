#!/usr/bin/env bash
set -eu -o pipefail

PROJECT=myproject
IMG=$PROJECT/myapp
VERSION=latest

REGISTRY=localhost:5000
ARCHS=(arm64 amd64)

## Internal variables
QUALIFIED=$REGISTRY/$IMG
MANIFEST=$QUALIFIED:$VERSION

TAGS=()
for arch in "${ARCHS[@]}"; do
  tag=$QUALIFIED-$arch:$VERSION
  docker build -t "$tag" --platform "linux/$arch" .
  docker push "$tag"
  TAGS+=(--amend "$tag")
done

docker manifest create --insecure $MANIFEST "${TAGS[@]}"
docker manifest push $MANIFEST
echo "all done"
