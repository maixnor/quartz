{
  description = "Quartz";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
				pkgs = import nixpkgs { 
					inherit system;

					config = {
						allowUnfree = true;
					};
				};
        nodeEnv = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs
            yarn
          ];

          shellHook = ''
            echo "    environment initialized ... "
            npm run check || npm run format
          '';
        };
      in
      {
        devShell = nodeEnv;
      });
}
