{
  stdenv,
  lib,
  fetchFromGitLab,
  libsixel,
  fetchpatch,
  gettext,
  pkg-config,
  meson,
  ninja,
  glib,
  gtk3,
  gtk4,
  gtkVersion ? "3",
  gobject-introspection,
  vala,
  python3,
  gi-docgen,
  libxml2,
  gnutls,
  gperf,
  pango,
  pcre2,
  cairo,
  fribidi,
  lz4,
  icu,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vte";
  version = "0.76.3";

  outputs = [
    "out"
    "dev"
  ] ++ lib.optional (gtkVersion != null) "devdoc";
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "vte";
    rev = "3c8f66be867aca6656e4109ce880b6ea7431b895";
    hash = "sha256-vz9ircmPy2Q4fxNnjurkgJtuTSS49rBq/m61p1B43eU=";
  }; # Piggybacking off of blackbox_terminal in nixpkgs

  patches = [
    # VTE needs a small patch to work with musl:
    # https://gitlab.gnome.org/GNOME/vte/issues/72
    # Taken from https://git.alpinelinux.org/aports/tree/community/vte3
    (fetchpatch {
      name = "0001-Add-W_EXITCODE-macro-for-non-glibc-systems.patch";
      url = "https://git.alpinelinux.org/aports/plain/community/vte3/fix-W_EXITCODE.patch?id=4d35c076ce77bfac7655f60c4c3e4c86933ab7dd";
      hash = "sha256-FkVyhsM0mRUzZmS2Gh172oqwcfXv6PyD6IEgjBhy2uU=";
    })
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    gperf
    libxml2
    meson
    ninja
    pkg-config
    vala
    python3
    gi-docgen
  ];

  buildInputs =
    [
      cairo
      fribidi
      gnutls
      libsixel
      pango # duplicated with propagatedBuildInputs to support gtkVersion == null
      pcre2
      lz4
      icu
      systemd
    ];

  # Required by vte-2.91.pc.
  propagatedBuildInputs = lib.optionals (gtkVersion != null) [
    (
      assert (gtkVersion == "3" || gtkVersion == "4");
      if gtkVersion == "3" then gtk3 else gtk4
    )
    glib
    pango
  ];

  mesonFlags =
    [
      "-Ddocs=true"
      (lib.mesonBool "gtk3" (gtkVersion == "3"))
      (lib.mesonBool "gtk4" (gtkVersion == "4"))
      "-Dsixel=true"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # -Bsymbolic-functions is not supported on darwin
      "-D_b_symbolic_functions=false"
    ];

  # error: argument unused during compilation: '-pie' [-Werror,-Wunused-command-line-argument]
  env.NIX_CFLAGS_COMPILE = toString (
    lib.optional stdenv.hostPlatform.isMusl "-Wno-unused-command-line-argument"
    ++ lib.optional stdenv.cc.isClang "-Wno-cast-function-type-strict"
  );

  postPatch = ''
    patchShebangs perf/*
    patchShebangs src/parser-seq.py
    patchShebangs src/modes.py
    patchShebangs src/box_drawing_generate.sh
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = with lib; {
    homepage = "https://www.gnome.org/";
    description = "Library implementing a terminal emulator widget for GTK";
    longDescription = ''
      VTE is a library (libvte) implementing a terminal emulator widget for
      GTK, and a minimal sample application (vte) using that.  Vte is
      mainly used in gnome-terminal, but can also be used to embed a
      console/terminal in games, editors, IDEs, etc. VTE supports Unicode and
      character set conversion, as well as emulating any terminal known to
      the system's terminfo database.
      This package supports sixel.
    '';
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
  };
})
