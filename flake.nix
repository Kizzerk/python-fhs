{
  description = "Python + Bash FHS Dev Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      python-env = pkgs.buildFHSUserEnv {
        name = "python-env";
          targetPkgs = pkgs: [
          pkgs.bash
          pkgs.bashInteractive
          pkgs.coreutils
          pkgs.git
          pkgs.curl
          pkgs.gcc
          pkgs.python3
          pkgs.python3Packages.venvShellHook
        ];
          # Optional: set HOME inside the container to make venvs cleaner
          extraMounts = {
            home = {
              source = "$HOME";
              target = "$HOME";
            };
          };
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          python-env
        ];
      };
    };
}
