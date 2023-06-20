# Building Multi-Architecture Docker Images

## References

* https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/
* https://danmanners.com/posts/2022-01-buildah-multi-arch/

## Struggles

* Error: short-name "ubuntu" did not resolve to an alias and no containers-registries.conf(5) was found
	> FROM docker.io/library/ubuntu:latest   (not just ubuntu:latest)
* Error: creating build container: open /etc/containers/policy.json: no such file or directory
	> provide file with --signature-policy
