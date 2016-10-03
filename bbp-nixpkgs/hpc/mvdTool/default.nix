{ stdenv, fetchgit, pkgconfig, boost, cmake, zlib, hdf5, highfive }:

stdenv.mkDerivation rec {
  name = "mvd-tool-${version}";
  version = "1.1";
  
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5];

  src = fetchgit {
    url = "https://github.com/BlueBrain/MVDTool.git";
    rev = "e5b0aa9deaf19d8bb37e81ecf9f56efecf5c5b54";
    sha256 = "0bgzqsf1q2v5m93v22dpb9sqp1cyfk6nfkccd5s6z0qfsi17ak4q";
  };
  
  cmakeFlags="-DUNIT_TESTS=TRUE";   

  enableParallelBuilding = true;
  
  doCheck = true;
  
  checkTarget = "test";

  propagatedBuildInputs = [ highfive ];
  
}


