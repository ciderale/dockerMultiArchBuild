# Building Multi-Architecture Docker Images

This repository is a little proof-of-concept script to build multi-architecture 
docker images. The script can be run as follows

```
REGISTRY=localhost:4000 IMG=myp/app nix run github:ciderale/dockerMultiArchBuild
```

and makes the following assumptions:

* `Dockerfile` in the working directory
* docker registry running locally on port 4000
* [nix](nixos.org) is installed with nix-flakes enabled
* docker system with multi-architecture build capabilities (arm64/arch64)

Notes:

* it seems docker manifest requires images to already be in the registry
* the script may need some tuning for custom parameters/args during build/push

## Devshell for experimentation

The project provides a devshell that sets environemnt variables REGISTR/IMG,
and provides scripts for starting/stopping a docker registry and running the images.

### Cloning the repository and entering the devshell

```
git clone git@github.com:ciderale/dockerMultiArchBuild.git
cd dockerMultiArchBuild
direnv allow      # or nix develop . --impure
```

The folling instructions, build, push, and runs the images:
```
# assume a local Dockerfile
dockerMultiArchBuild  # builds the images and pushes to local registry
runArm                # should display arm architecture
runAmd                # should display amd architecture
registryStop          # starts a local docker registry
exit
```

Alternatively, the devshell can be started without cloning the repo
```
nix develop github:ciderale/dockerMultiArchBuild --impure
```
but then a Dockerfile has to be provided by the user.

## References

* https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/
