{
  description = "Inkscape Figures - flake-enabled Python CLI tool";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          pyperclip
          click
          appdirs
          daemonize
        ]);
      in {
        packages.inkscape-figures = pkgs.python3Packages.buildPythonPackage {
          pname = "inkscape-figures";
          version = "1.0.7";
          src = ./.;

          propagatedBuildInputs = with pkgs.python3Packages; [
            pyperclip
            click
            appdirs
            daemonize
          ];

          nativeBuildInputs = [ pkgs.fswatch ];

          doCheck = false;

          meta = with pkgs.lib; {
            description = "Script for managing Inkscape figures";
            homepage = "https://github.com/gillescastel/inkscape-figures";
            license = licenses.mit;
          };
        };

        defaultPackage = self.packages.${system}.default;

        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.default;
          name = "inkscape-figures";
        };
      }
    );
}

