{ pkgs ? import <nixpkgs> { } }:
let
  stdenv =
    pkgs.stdenv;
in
stdenv.mkDerivation {
  name = "nix-darwin-docset";
  src = ./.;

  nativeBuildInputs = with pkgs; [
    curl
    python310
    python310Packages.beautifulsoup4
  ];

  buildPhase = ''
    mkdir -p nix-darwin.docset/Contents/Resources/Documents/

    cp index.html nix-darwin.docset/Contents/Resources/Documents/index.html

    cp Info.plist nix-darwin.docset/Contents/

    python3 ./gen_index.py \
      nix-darwin.docset/Contents/Resources/Documents/index.html \
      -o nix-darwin.docset/Contents/Resources/docSet.dsidx
  '';

  installPhase = ''
    mkdir -p $out
    mv nix-darwin.docset $out
  '';
}
