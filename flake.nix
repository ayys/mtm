{
  description = "ayys's fork of mtm";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flakeutils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, flakeutils }:
      flakeutils.lib.eachDefaultSystem (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          packages = rec {
            mtm = pkgs.stdenv.mkDerivation {
              name = "mtm";
              src = ./.;
              buildInputs = [
                pkgs.gcc pkgs.ncurses
              ];
              buildPhase = ''
          make
        '';
              installPhase = ''
          TERMINFO="$out" make install DESTDIR="$out" PREFIX=""
        '';
            };
            default = mtm;
          };
          apps = rec {
            mtm = flakeutils.lib.mkApp { drv = self.packages.${system}.mtm; };
            default = mtm;
          };
        }
      );
}
