{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  dpkg,
  #libs
  glib,
  nss,
  xorg,
  libgcc,
  cups,
  expat,
  dbus,
  pango,
  cairo,
  at-spi2-atk,
  gtk3,
  gdk-pixbuf,
  alsa-lib,
  libudev0-shim,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "QuickQ";
  version = "1.0";
  src = fetchurl {
    url = "https://d.asdfgh.win/quickq/download/linux-quickq.deb";
    sha256 = "1g1bcvsxj8pkyk0y1mvw71lrdc4y2d807q52lk1vhxanmlmvnb9j";

  };
  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
    libudev0-shim
  ];
  buildInputs = [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    gdk-pixbuf
    libgcc
    libudev0-shim
    nss
    pango
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    xorg.libXrandr
    xorg.libXScrnSaver
  ];
  installPhase = ''
    dpkg -x $src $out
    chmod 755 $out
  '';
  preFixup =
    let
      runtimeLibs = lib.makeLibraryPath [ libudev0-shim ];
    in
    ''
      wrapProgram "$out/opt/QuickQ/QuickQ" --prefix LD_LIBRARY_PATH : ${runtimeLibs}
    '';
}
