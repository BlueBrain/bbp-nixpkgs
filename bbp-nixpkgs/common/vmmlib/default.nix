{ stdenv, fetchgitExternal, cmake, doxygen, python, blas  }:

stdenv.mkDerivation rec {
  name = "vmmlib-1.8.0-DEV";
  buildInputs = [ stdenv cmake doxygen python blas];

  src = fetchgitExternal {
    url = "https://github.com/Eyescale/vmmlib.git";
    rev= "60b5db5fb91885c75f5b6f89907e2d5422186b75";
    sha256 = "04zkixp8sljlvzr4l43j2p90mzxlzb24p2nrcgz0qap1yd0b78i3";
  };


  enableParallelBuilding = true;
}


