# Building Multi-Architecture Docker Images

## Expriment with the code (without cloning/direnv)

```
nix develop github:ciderale/dockerMultiArch --impure
registryStart    # starts a local docker registry
dockerMultiArch  # builds the images and pushes to local registry
runArm           # should display arm architecture
runAmd           # should display amd architecture
registryStop     # starts a local docker registry
exit
```

## References

* https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/
