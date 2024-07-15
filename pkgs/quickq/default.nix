{ stdenv, lib, fetchurl }:
stdenv.mkDerivation rec {
  name = "quickq";
  version = "138";

  src = fetchurl {
    url = "https://d.qwe6.link/quickq/download/linux-quickq.tar.gz";
    hash = "sha256-owz13yIX63PjRwbaLi75j6bN6m0ZCBZDsYAUZ8nLgds=";
  };
  sourceRoot = ".";
  unpackPhase = "tar -xzvf $src";

  preInstall = ''
    echo "#!/bin/sh" > quickq.sh
    echo 'mkdir -p "$HOME/quickq"'          >> quickq.sh # 创建数据目录

    echo  'cp linux-quickq-server quickqservice geosite.dat geoip.dat "$HOME/quickq/"'  >> quickq.sh

    chmod +x quickq.sh
    '';
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # move files to nix store
    mkdir -p $out/bin
    cp linux-quickq-server quickqservice geosite.dat geoip.dat quickq.sh $out/bin/
    # give exec rights
    chmod +x linux-quickq-server

    runHook postInstall
  '';
  preFixup = let
    # we prepare our library path in the let clause to avoid it become part of the input of mkDerivation
    libPath = lib.makeLibraryPath [
      stdenv.cc.cc.lib  # libstdc++.so.6
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/bin/linux-quickq-server
      '';

  meta = with lib; {
    homepage = "https://www.quickq.io/";
    description = "QuickQ vpn";
    platforms = platforms.linux;
  };
}
