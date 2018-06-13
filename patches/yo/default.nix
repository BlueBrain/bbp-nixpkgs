{
  boost,
  cmake,
  fetchFromGitHub,
  stdenv
}:

stdenv.mkDerivation rec {
  name = "yo-${version}";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "adevress";
    repo = "yo";
    rev = "9453789dcbea651831c0e4c7af86e740088fcdf0";
    fetchSubmodules = true;
    sha256 = "1mq54h144n2lrm91b69i6i65s2v0kmqkpjv9m2xbs6zs5s8cbywb";
  };

  meta = {
    description = "The Parallel I/O toolkit";
    longDescription = "";
    platforms = stdenv.lib.platforms.all;
    homepage = "https://github.com/adevress/yo";
    license = stdenv.lib.licenses.gpl3;
  };

  buildInputs = [
    boost
    cmake
  ];

}
