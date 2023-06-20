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
        packages.dockerMultiArchBuild = pkgs.writeShellApplication {
          name = ''dockerMultiArchBuild'';
          runtimeInputs = [pkgs.docker];
          text = ./builder.sh;
        };
        devenv.shells.default = {lib, ...}: {
          name = "my-project";
          env.PROJECT = "myp";
          env.IMG = "app";
          env.VERSION = inputs.self.rev or "latest";
          containers = lib.mkForce {};

          packages = builtins.attrValues {
            inherit (pkgs) docker;
            inherit (self'.packages) dockerMultiArchBuild;
          };
          pre-commit.hooks.shellcheck.enable = true;
          pre-commit.hooks.shellcheck.types_or = ["shell"];

          scripts.registryStart.exec = ''docker run -d -p 5000:5000 --name registry registry:2'';
          scripts.registryStop.exec = ''docker rm --force registry'';

          scripts.runArm.exec = ''docker run -ti --platform linux/arm64 localhost:5000/$PROJECT/$IMG:$VERSION'';
          scripts.runAmd.exec = ''docker run -ti --platform linux/amd64 localhost:5000/$PROJECT/$IMG:$VERSION'';

          enterShell = ''echo ${inputs.self.rev or "dirty"}'';
        };
      };
    };
}
