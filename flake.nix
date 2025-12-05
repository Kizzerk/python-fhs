{
  description = "Python + Bash FHS Dev Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default =

        pkgs.buildFHSUserEnvBubblewrap {
          name = "pybash-dev";
          targetPkgs = pkgs: with pkgs; [
            bashInteractive
            git
            curl
            gcc
            python3
            python3Packages.venvShellHook
          ];

          # Launch into bash by default
          runScript = "bash";

          # Optional: set HOME inside the container to make venvs cleaner
          extraMounts = {
            home = {
              source = "$HOME";
              target = "$HOME";
            };
          };
        };
    };
}
