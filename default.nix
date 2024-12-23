# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{
  pkgs ? import <nixpkgs> { },
}:

rec {
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  example-package = pkgs.callPackage ./pkgs/example-package { };
  beatoraja = pkgs.callPackage ./pkgs/beatoraja { libjportaudio = libjportaudio; };
  libjportaudio = pkgs.callPackage ./pkgs/libjportaudio { };
  vte-sixel = pkgs.callPackage ./pkgs/vte-sixel { };
  # wechat-uos = pkgs.callPackage ./pkgs/wechat-uos { };
  quickq = pkgs.callPackage ./pkgs/quickq { };
  # xfce4-terminal = pkgs.callPackage ./pkgs/xfce4-terminal{ };
  # some-qt5-package = pkgs.libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
}
