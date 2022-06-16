{
  description = "IPGen Command Line Tool";

  inputs = {
    import-cargo.url = "github:edolstra/import-cargo";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, import-cargo, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let

        binary = "ipgen";
        package = "${binary}-cli";

        pkgs = nixpkgs.legacyPackages.${system};

        cargoHome = (import-cargo.builders.importCargo {
          lockFile = ./Cargo.lock;
          inherit pkgs;
        }).cargoHome;

      in with pkgs; {

        packages.${package} = stdenv.mkDerivation {
          name = package;
          src = self;

          nativeBuildInputs = [ cargoHome rustc cargo ];

          buildPhase = ''
            cargo build --release --offline
          '';

          installPhase = ''
            install -Dm775 ./target/release/${binary} $out/bin/${binary}
          '';

          meta = {
            mainProgram = binary;
          };
        };

        defaultPackage = self.packages.${system}.${package};

        devShell = mkShell {
          inputsFrom = builtins.attrValues self.packages.${system};
          buildInputs = [ cargo rust-analyzer clippy ];
        };
      }
    );
}
