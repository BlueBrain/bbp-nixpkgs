{
  boost,
  cmake,
  python,
  pkgconfig,
  fetchFromGitHub,
  stdenv
}:

stdenv.mkDerivation rec {
  name = "yo-${version}";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "adevress";
    repo = "yo";
    rev = "8058fbc4251dd5bfd788ea58b3d58e934626f6a8";
    fetchSubmodules = true;
    sha256 = "0y64di0jwmqiq5a7ir7m9s93vy5gc13k3afalcar7nw10lirz4pr";
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
    python
    pkgconfig
  ];

}
