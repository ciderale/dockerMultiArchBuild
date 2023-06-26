#!/usr/bin/env bash
set -eu -o pipefail

#IMG=${IMG:-myproject/myapp}
#REGISTRY=${REGISTRY:-localhost:5000}
#VERSION=${VERSION:-latest}
OPTS="--insecure"
PATTERN="reference=$IMG-*:$VERSION"
MANIFEST=$REGISTRY/$IMG:$VERSION

echo "###############"
TAGS=$(docker images --filter "$PATTERN" --format '{{.Repository}}:{{.Tag}}' | xargs)
echo "### Re-Tag and Push images: $TAGS"
QTAGS=()
for tag in $TAGS; do
  qtag=$REGISTRY/$tag
  docker tag "$tag" "$qtag"
  docker push "$qtag"
  QTAGS+=("$qtag")
done

echo "###############"
echo "### Building manifest $MANIFEST"
docker manifest create $OPTS "$MANIFEST" "${QTAGS[@]}"
docker manifest push "$MANIFEST"
echo "DONE. all done: $MANIFEST"
