# Building Multi-Architecture Docker Images

```
nix develop github:ciderale/dockerMultiArchBuild --impure
registryStart         # starts a local docker registry
# assume a local Dockerfile
dockerMultiArchBuild  # builds the images and pushes to local registry
runArm                # should display arm architecture
runAmd                # should display amd architecture
registryStop          # starts a local docker registry
exit
```

## References

* https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/
