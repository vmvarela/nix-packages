{
  description = "Nix packages for vmvarela tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      # The shared Nix receiver writes pkgs/zepp-life/versions.json on the first
      # update-zepp-life release; until then the flake must stay evaluable.
      hasZeppLife = builtins.pathExists ./pkgs/zepp-life/versions.json;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          sql-pipe = pkgs.callPackage ./pkgs/sql-pipe/package.nix { };
          default = self.packages.${system}.sql-pipe;
        } // nixpkgs.lib.optionalAttrs hasZeppLife {
          zepp-life = pkgs.callPackage ./pkgs/zepp-life/package.nix { };
        }
      );

      overlays.default = final: _prev: {
        sql-pipe = final.callPackage ./pkgs/sql-pipe/package.nix { };
      } // nixpkgs.lib.optionalAttrs hasZeppLife {
        zepp-life = final.callPackage ./pkgs/zepp-life/package.nix { };
      };
    };
}
