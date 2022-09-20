{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    curl
    sqlite
    python310
    python310Packages.beautifulsoup4
    python310Packages.ipython
    python310Packages.black
  ];
}
