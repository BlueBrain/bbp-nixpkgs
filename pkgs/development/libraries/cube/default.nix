{ stdenv, fetchurl, which, zlib, qt}:

stdenv.mkDerivation rec {
  name = "cube-4.3.1";
  buildInputs = [ stdenv which zlib qt];

  # configure script need bash, not sh
  configureScript = "bash ./configure";

  src = fetchurl {
    url = "http://apps.fz-juelich.de/scalasca/releases/cube/4.3/dist/cube-4.3.1.tar.gz";
    sha256 = "1a7f566cfdd758ce6e380dfce08cb3bddd4ce3aff7a5f3a81376c365b90c2679";
  };

  enableParallelBuilding = true;
}





