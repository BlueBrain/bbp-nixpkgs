{ stdenv, fetchurl, which, mpich2, cube,  zlib, gfortran }:

stdenv.mkDerivation rec {
  name = "scorep-1.4.1";
  buildInputs = [ stdenv mpich2 which cube zlib gfortran ];

  src = fetchurl {
    url = "http://www.vi-hps.org/upload/packages/scorep/scorep-1.4.1.tar.gz";
    sha256 = "0e16b8816e7c830c00c0868bbe8f5fe6ce7a6f7de12ecbf42fe4bca0f44c3b02";
  };
  
  configureFlagsArray=("--with-cube=${cube}/bin");  

  enableParallelBuilding = true;
}


