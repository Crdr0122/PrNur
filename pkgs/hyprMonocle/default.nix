{
  lib,
  fetchFromGitHub,
  hyprland,
  hyprlandPlugins,
  stdenv,
  pkg-config,
}:
stdenv.mkDerivation {
  pname = "hyprMonocle";
  version = "0.44.1";

  src = ./hyprlandMonocle;
  # src = fetchFromGitHub {
  #   owner = "zakk4223";
  #   repo = "hyprlandMonocle";
  #   rev = "d50dca4496c7908fcbbc9e78353738d64935002a";
  #   hash = "sha256-RWp7g6mBnpKKvB+8A46jJyaVX2KrIjcUW2/8tPDGhu4=";
  # };
  # any nativeBuildInputs required for the plugin
  nativeBuildInputs = [
    pkg-config
  ];

  # set any buildInputs that are not already included in Hyprland
  # by default, Hyprland and its dependencies are included
  buildInputs = [ hyprland ] ++ hyprland.buildInputs;

  buildPhase = ''make all'';
  installPhase = ''
    mkdir -p $out/lib
    cp monocleLayoutPlugin.so $out/lib/hyprMonocle.so
  '';

  meta = {
    homepage = "https://github.com/zakk4223/hyprlandMonocle";
    description = "Hyprland monocle layout";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
