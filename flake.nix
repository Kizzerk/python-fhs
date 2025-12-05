{
  description = "Python + Bash FHS Dev Environment (Fully FHS in nix develop)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        # Basic packages in the outer shell (optional)
        buildInputs = [
          pkgs.git
          pkgs.curl
        ];

        shellHook = ''
          # Launch the real FHS environment only once
          if [ -z "$FHS_ACTIVE" ]; then
            export FHS_ACTIVE=1

            exec ${pkgs.buildFHSUserEnvBubblewrap {
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

              # Optional: keep locale settings
              # set LANG, LC_ALL to avoid Python locale warnings
              shellHook = ''
                export LANG="${pkgs.stdenv.cc.cc.libcLocale}"
                export LC_ALL="$LANG"
                export PIP_CACHE_DIR="$HOME/.cache/pip"
                export VIRTUAL_ENV_DISABLE_PROMPT=1

                # Auto-activate .venv if it exists
                if [ -d ".venv" ]; then
                  source .venv/bin/activate
                fi
              '';
            }}/bin/bash
          fi
        '';
      };
    };
}
