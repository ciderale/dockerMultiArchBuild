#!/usr/bin/env bash
set -eu -o pipefail

#IMG=${IMG:-myproject/myapp}
#VERSION=${VERSION:-latest}

echo "###############"
echo "# simple loop over architectures for individual images"
ARCHS=(arm64 amd64)
for arch in "${ARCHS[@]}"; do
  tag=$IMG-$arch:$VERSION
  docker build -t "$tag" --platform "linux/$arch" . &
done

wait
