{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = ["x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        packages.default = pkgs.writeShellApplication {
          name = ''dockerMultiArchBuildAndPublish'';
          text = ''
            ${self'.packages.build}/bin/dockerMultiArchBuild
            ${self'.packages.publish}/bin/dockerMultiArchPublish
          '';
        };
        packages.build = pkgs.writeShellApplication {
          name = ''dockerMultiArchBuild'';
          runtimeInputs = [pkgs.docker];
          text = ./multi-arch-build.sh;
        };
        packages.publish = pkgs.writeShellApplication {
          name = ''dockerMultiArchPublish'';
          runtimeInputs = [pkgs.docker];
          text = ./multi-arch-publish.sh;
        };
        devenv.shells.default = {lib, ...}: let
          port = "4000";
        in {
          name = "my-project";
          env.IMG = "myp/app";
          env.VERSION = inputs.self.rev or "latest";
          env.REGISTRY = "localhost:${port}";
          containers = lib.mkForce {};

          packages = builtins.attrValues {
            inherit (pkgs) docker;
            inherit (self'.packages) default build publish;
          };
          pre-commit.hooks.shellcheck.enable = true;
          pre-commit.hooks.shellcheck.types_or = ["shell"];

          scripts.registryStart.exec = ''docker run -d -p ${port}:5000 --name registry registry:2'';
          scripts.registryStop.exec = ''docker rm --force registry'';

          scripts.runArm.exec = ''docker run -ti --platform linux/arm64 $REGISTRY/$IMG:$VERSION'';
          scripts.runAmd.exec = ''docker run -ti --platform linux/amd64 $REGISTRY/$IMG:$VERSION'';

          enterShell = ''echo ${inputs.self.rev or "dirty"}'';
        };
      };
    };
}
