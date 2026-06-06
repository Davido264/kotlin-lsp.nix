{
  lib,
  stdenv,
  zlib,
  gradle,
  makeWrapper,
  openjdk,
  android-tools,
}:

let
  version = "0.9.40";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "dta-cli";
  inherit version;

  src = fetchTarball {
    url = "https://github.com/yamsergey/dta/releases/download/${version}/dta-cli-${version}.tar.gz";
    sha256 = "sha256:08am50i9yigcgra65jwpi2nhmqyhiw731bb6m0hnr46s597zingw";
  };

  nativeBuildInputs = [
    stdenv.cc.cc.lib # libgcc_s.so.1, libstdc++.so.6
    gradle
    makeWrapper
    # for native JNI libs (rocksdbjni, filewatcher),
    # for the bundled JBR (libjli, libzip, libinstrument, etc.)
    zlib
    android-tools
  ];
  buildInputs = [
    openjdk
    gradle
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib

    cp -r lib/* $out/lib
    cp bin/dta-cli $out/bin/
  '';

  postFixup = ''
    wrapProgram $out/bin/dta-cli \
        --set JAVA_HOME ${openjdk} \
        --prefix PATH : ${
          lib.makeBinPath [
            stdenv.cc.cc.lib
            gradle
            android-tools
            openjdk
          ]
        }
  '';
})
