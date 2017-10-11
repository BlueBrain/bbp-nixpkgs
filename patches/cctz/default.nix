{
  stdenv,
  fetchFromGitHub
}:

stdenv.mkDerivation rec {
  name = "cctz-${version}";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cctz";
    rev = "d5e227e6bfdb365abb12ec7528d79292732ce0bc";
    sha256 = "1j60kz9jwnh9nabwbaavi7d57l0w1candyydqscn4ymafkzn9dhh";
  };

  buildInputs = [
    stdenv
  ];

  configurePhase = ''
    mkdir build
    export PREFIX=$out
    echo Output is $out
  '';

  makeFlags = ''-C build -f ../Makefile SRC=../  CCTZ_SHARED_LIB=libcctz.so.2.0'';

  installTargets = "install install_shared_lib";
}