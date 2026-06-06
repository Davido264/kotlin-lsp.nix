{
  lib,
  stdenv,
  openjdk,
  gradle,
  makeWrapper,
  maven,
}:

stdenv.mkDerivation {
  pname = "kotlin-lsp";
  version = "v262.2310.0";
  src = fetchTarball {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/262.4739.0/kotlin-server-262.4739.0.tar.gz";
    sha256 = "0rzvq9apirn8f350rnflabn2d029zzm65van4z3xq0m7jg5byli3";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];
  buildInputs = [
    openjdk
    gradle
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    mv ./* $out/
    ln -s $out/kotlin-lsp.sh $out/bin/kotlin-lsp
  '';

  postFixup = ''
    wrapProgram $out/bin/kotlin-lsp \
        --set JAVA_HOME ${openjdk} \
        --prefix PATH : ${
          lib.makeBinPath [
            gradle
            maven
            openjdk
          ]
        }
  '';
}
