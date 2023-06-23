#!/usr/bin/env bash
set -eu -o pipefail

# note the naming convention 'repo/img-arch:tag'
#  - manifest/multi-arch image: 'repo/img:tag'
#  - the arch-specific images:  'repo/img-arch:tag'
# building is decoupled from manifest & repo pushing
# as long as the naming convention is respected
# the naming convention is used to discover images that belong together

# IMG & VERSION must be always be defined
# REGISTRY must be defined for publishing
#IMG=${IMG:-myproject/myapp}
#REGISTRY=${REGISTRY:-localhost:5000}
VERSION=${VERSION:-latest}


echo "###############"
echo "# simple loop over architectures for individual images"
ARCHS=(arm64 amd64)
for arch in "${ARCHS[@]}"; do
  tag=$IMG-$arch:$VERSION
  docker build -t "$tag" --platform "linux/$arch" .
done

echo "###############"
# WHAT: IMG & VERSION must be defined
# WHERE: REPOSITORY where should the manifest go
TAGS=$(docker images --filter "reference=$IMG-*:$VERSION" --format '{{.Repository}}:{{.Tag}}' | xargs)
echo "### Re-Tag and Push images: $TAGS"
QTAGS=()
for tag in $TAGS; do
  qtag=$REGISTRY/$tag
  docker tag "$tag" "$qtag"
  docker push "$qtag"
  QTAGS+=("$qtag")
done

MANIFEST=$REGISTRY/$IMG:$VERSION
echo "###############"
echo "### Building manifest $MANIFEST"
docker manifest create --insecure "$MANIFEST" "${QTAGS[@]}"
docker manifest push "$MANIFEST"
echo "DONE. all done: $MANIFEST"
