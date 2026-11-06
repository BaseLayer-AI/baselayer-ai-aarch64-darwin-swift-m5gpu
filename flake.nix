{
  description = "aarch64-darwin M5 GPU Demo";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*";

  outputs = { self, nixpkgs }: 
    let 
      aarch64-darwin = import nixpkgs { system = "aarch64-darwin"; };

      default = { pkgs } :
        pkgs.stdenv.mkDerivation {
          pname = "baselayer-ai-aarch64-darwin-swift-m5gpu";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = [ pkgs.swift ];
          buildInputs = [ ];

          buildPhase = ''
            swiftc ./main.swift -o baselayer-ai-aarch64-darwin-swift-m5gpu
          '';

          installPhase = ''
            APP_DIR="$out/Applications/NixNativeGUI.app/Contents"
            mkdir -p "$APP_DIR/MacOS"
            mkdir -p "$APP_DIR/Resources"

            cp baselayer-ai-aarch64-darwin-swift-m5gpu "$APP_DIR/MacOS/"
            cp Info.plist "$APP_DIR/"
          '';
        };

    in {
      packages.aarch64-darwin.default = default { pkgs = aarch64-darwin; };
      apps.aarch64-darwin.default = { type = "app";
        program = "${self.packages.aarch64-darwin.default}/Applications/NixNativeGUI.app/Contents/MacOS/baselayer-ai-aarch64-darwin-swift-m5gpu";};
   };
}
