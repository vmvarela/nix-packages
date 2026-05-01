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
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          sql-pipe = pkgs.callPackage ./pkgs/sql-pipe/package.nix { };
          default = self.packages.${system}.sql-pipe;
        }
      );

      overlays.default = final: _prev: {
        sql-pipe = final.callPackage ./pkgs/sql-pipe/package.nix { };
      };
    };
}
