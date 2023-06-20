# Building Multi-Architecture Docker Images

## References

* https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/
* https://danmanners.com/posts/2022-01-buildah-multi-arch/

## Struggles

* Error: short-name "ubuntu" did not resolve to an alias and no containers-registries.conf(5) was found
	> FROM docker.io/library/ubuntu:latest   (not just ubuntu:latest)
* Error: creating build container: open /etc/containers/policy.json: no such file or directory
	> provide file with --signature-policy
* Error: building at STEP "RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*": function not supported on non-linux systems
	> https://github.com/containers/buildah/issues/156
	> buildah does not to the remote/vm thing on mac
	> so that path is not helpful for building the images
