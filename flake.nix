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

        pkgs.buildFHSUserEnv {
          name = "pybash-dev";
          targetPkgs = pkgs: with pkgs; [
            bash
            bashInteractive
            coreutils
            git
            curl
            gcc
            python3
            python3Packages.venvShellHook
          ];

          # This ensures /bin/bash and other interpreter paths appear **inside the FHS**.
          extraOutputsToInstall = [ "bin" ];
          
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
