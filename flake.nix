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
          # Packages to include inside the FHS root          
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

          # Ensure /bin/bash and bin paths exist inside FHS
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
          /*
          # Optional: persist pip cache to your home
          shellHook = ''
            export PIP_CACHE_DIR="$HOME/.cache/pip"
            export VIRTUAL_ENV_DISABLE_PROMPT=1

            # Auto-create and activate a .venv if it exists
            if [ -d ".venv" ]; then
              source .venv/bin/activate
            fi
          '';
          */
        };
    };
}
