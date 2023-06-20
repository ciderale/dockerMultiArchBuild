set -x
set -eu -o pipefail
MANIFEST=localhost:5000/localhost/myt
TAG=localhost:5000/localhost/myt

ARCHS=(arm64 amd64)
TAGS=()
for arch in "${ARCHS[@]}"; do
  tag=$TAG:$arch
  docker build -t $tag --platform linux/$arch .
  docker push $tag
  TAGS+=(--amend $tag)
  #docker manifest create --insecure $MANIFEST --amend $tag

  #buildah --signature-policy policy.json from  docker-daemon:$TAG:latest
  #buildah manifest add multiarch-test docker-daemon:$TAG:latest
  #
  #echo "XXX $imgid XXX"
  #buildah bud --signature-policy policy.json --arch arm64 --os linux
done

docker manifest create --insecure $MANIFEST "${TAGS[@]}"
docker manifest push $MANIFEST
echo "all done"

#buildah manifest push --all --tls-verify=false --signature-policy policy.json \
#  multiarch-test docker://localhost:5000/me/multi-t:latest
#buildah manifest push --signature-policy policy.json multiarch-test docker-daemon:multi-t:latest
