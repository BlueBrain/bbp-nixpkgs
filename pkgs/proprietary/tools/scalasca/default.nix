{ stdenv, fetchurl, which, mpich2, scorep, cube, zlib }:

stdenv.mkDerivation rec {
  name = "scalasca-2.2.1";
  buildInputs = [ stdenv scorep cube which zlib mpich2 ];
  src = fetchurl {
    url = "http://apps.fz-juelich.de/scalasca/releases/scalasca/2.2/dist/scalasca-2.2.1.tar.gz";
    sha256 = "f7e8615152d571c4f78d2a3a5512f0960f8f9d6268a9832681e438919f1d5d94";
  };

  configureFlagsArray=("--with-cube=${cube}/bin");

  enableParallelBuilding = true;
}



