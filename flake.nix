{
  description = "Quartz";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs
            yarn
          ];
        };

        checks = pkgs.stdenv.mkDerivation {
          name = "${self.pname}-tests";

          buildInputs = with pkgs; [
            nodejs
            yarn
          ];

          src = ./.;

          buildPhase = ''
            # Install dependencies
            yarn install

            # Run tests and linters
            yarn run lint
            yarn run test
          '';
        };
      });
}