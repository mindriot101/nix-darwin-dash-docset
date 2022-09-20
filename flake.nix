{
  description = "Description for the project";

  inputs = {
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit self; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages.default = import ./default.nix {
          inherit pkgs;
        };
        devShells.default = import ./shell.nix {
          inherit pkgs;
        };
      };
    };
}
