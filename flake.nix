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
      devShells.${system}.default = pkgs.buildFHSUserEnvBubblewrap {
        name = "pybash-dev";

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

        runScript = "bash";
        extraOutputsToInstall = [ "bin" ];

        extraMounts = {
          home = { source = "$HOME"; target = "$HOME"; };
        };

        shellHook = ''
          export LANG=C.UTF-8
          export LC_ALL=C.UTF-8
          export PIP_CACHE_DIR="$HOME/.cache/pip"
          export VIRTUAL_ENV_DISABLE_PROMPT=1

          if [ -d ".venv" ]; then
            source .venv/bin/activate
          fi
        '';
      };
    };
}
