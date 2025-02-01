{
  meson,
  pkg-config,
  ninja,
  wayland,
  wayland-protocols,
  wayland-scanner,
  scdoc,
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wooz";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "negrel";
    repo = "wooz";
    rev = "eb342ae8383300535b5cca141b76921400d04d1b";
    hash = "sha256-q7Ru1o0uLxqc2nx0HnX1kpyKXxjnzYIlFi1pykaLMF8=";
  };


  buildInputs = [
    meson
    pkg-config
    ninja
    wayland
    wayland-protocols
    wayland-scanner
    scdoc
  ];


  meta = with lib; {
    description = "Zoom in for wayland compositors";
    platforms = platforms.unix;
  };
})
