{
  description = "IPGen Command Line Tool";

  inputs = { import-cargo.url = "github:edolstra/import-cargo"; };

  outputs = { self, nixpkgs, import-cargo }:
    let

      inherit (import-cargo.builders) importCargo;

    in {

      defaultPackage.x86_64-linux =
        with import nixpkgs { system = "x86_64-linux"; };
        stdenv.mkDerivation rec {
          name = "ipgen";
          src = self;

          nativeBuildInputs = [
            (importCargo {
              lockFile = ./Cargo.lock;
              inherit pkgs;
            }).cargoHome

            rustc
            cargo
          ];

          buildPhase = ''
            cargo build --release --offline
          '';

          installPhase = ''
            install -Dm775 ./target/release/${name} $out/bin/${name}
          '';
        };
    };
}
