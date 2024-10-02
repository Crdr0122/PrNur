{
  lib,
  mkXfceDerivation,
  glib,
  gtk3,
  libsixel,
  sixelSupport ? true,
  gtk-layer-shell,
  libX11,
  libxfce4ui,
  vte,
  fetchFromGitLab,
  xfconf,
  pcre2,
  libxslt,
  docbook_xml_dtd_45,
  docbook_xsl,
}:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-terminal";
  version = "1.1.3";
  odd-unstable = false;

  sha256 = "sha256-CUIQf22Lmb6MNPd2wk8LlHFNUhdIoC1gzVV6RDP2PfY=";

  nativeBuildInputs = [
    libxslt
    docbook_xml_dtd_45
    docbook_xsl
  ];

  buildInputs = [
    glib
    gtk3
    gtk-layer-shell
    libX11
    libxfce4ui
    vte
    (vte.overrideAttrs (
      old:
      {
        src = fetchFromGitLab {
          domain = "gitlab.gnome.org";
          owner = "GNOME";
          repo = "vte";
          rev = "3c8f66be867aca6656e4109ce880b6ea7431b895";
          hash = "sha256-vz9ircmPy2Q4fxNnjurkgJtuTSS49rBq/m61p1B43eU=";
        };
        postPatch =
          (old.postPatch or "")
          + ''
            patchShebangs src/box_drawing_generate.sh
          '';
      }
      // lib.optionalAttrs sixelSupport {
        buildInputs = old.buildInputs ++ [ libsixel ];
        mesonFlags = old.mesonFlags ++ [ "-Dsixel=true" ];
      }
    ))
    xfconf
    pcre2
  ];

  meta = {
    description = "Modern terminal emulator";
    mainProgram = "xfce4-terminal";
  };
}
