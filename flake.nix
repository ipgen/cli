{
  inputs = {
    cargo2nix.url = "github:cargo2nix/cargo2nix/release-0.11.0";
    flake-utils.follows = "cargo2nix/flake-utils";
    nixpkgs.follows = "cargo2nix/nixpkgs";
  };

  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ cargo2nix.overlays.default ];
        };

        cargoToml = (builtins.fromTOML (builtins.readFile ./Cargo.toml));

        rustPkgs = pkgs.rustBuilder.makePackageSet {
          rustVersion = "1.61.0";
          packageFun = import ./Cargo.nix;
          extraRustComponents = [ "rustfmt" "clippy" ];

          packageOverrides = pkgs: pkgs.rustBuilder.overrides.all ++ [
            (pkgs.rustBuilder.rustLib.makeOverride {
              name = cargoToml.package.name;
              overrideAttrs = drv: {
                meta.mainProgram = "ipgen";
              };
            })
          ];
        };

      in rec {
        packages = {
          ${cargoToml.package.name} =
            (rustPkgs.workspace.${cargoToml.package.name} { }).bin;
          default = packages.${cargoToml.package.name};
        };
      });
}
