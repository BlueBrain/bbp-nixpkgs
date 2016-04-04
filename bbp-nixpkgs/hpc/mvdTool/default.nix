{ stdenv, fetchgit, pkgconfig, boost, cmake, zlib, hdf5 }:

stdenv.mkDerivation rec {
  name = "mvdTool-1.0-DEV";
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5];

  src = fetchgit {
    url = "https://github.com/BlueBrain/MVDTool.git";
    rev = "f4acff6237f8768e660dd3dcf9d192316eac22bf";
    sha256 = "0x92r782ig2irs04x4snz309hpa3gsx6rbfppwr9pnppz1mz22i4";
  };
  
  cmakeFlags="-DUNIT_TESTS=TRUE";   

  enableParallelBuilding = true;
  
  doCheck = true;
  
  checkTarget = "test";
  
}


