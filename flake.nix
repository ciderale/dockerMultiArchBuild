{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
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
        devenv.shells.default = {
          name = "my-project";
          env.PROJECT = "myp";
          env.IMG = "app";
          env.VERSION = inputs.self.rev or "latest";

          packages = builtins.attrValues {
            inherit (pkgs) docker;
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
