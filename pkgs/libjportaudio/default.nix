{ stdenv
, fetchFromGitHub
, oraclejdk8 # 废话
, cmake      # 使用cmake进行构建
, portaudio  # 依赖libportaudio.so
}:

let
  version = "0.1.0";
  pname = "libjportaudio";
  jdk = oraclejdk8.overrideAttrs {
    src = fetchTarball {
      url = "https://static.sora.zip/nix/jdk-8u281-linux-x64.tar.gz";
      sha256 = "0f9fb37p75cf7qfm67yc8ariqksnw8641kh2zcwvlrr4r8lgj70v";
    };
  };
in
stdenv.mkDerivation rec {
  inherit version pname;
  name = "${pname}-${version}";
  src = fetchFromGitHub ({
    owner = "philburk";
    repo = "portaudio-java";
    rev = "2ec5cc47d6f8abe85ddb09c34e69342bfe72c60b";
    sha256 = "t+Pqtgstd1uJjvD4GKomZHMeSECNLeQJOrz97o+lV2Q=";
  });

  nativeBuildInputs = [ cmake portaudio ];

  preConfigure = ''
    export JAVA_HOME=${jdk}
  '';

  # configurePhase会自动执行cmake

  buildPhase = ''
    make jportaudio_0_1_0
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp libjportaudio_0_1_0.so $out/lib/libjportaudio.so
  '';
}
