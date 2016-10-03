{ stdenv, fetchgit, pkgconfig, boost, cmake, zlib, hdf5, highfive }:

stdenv.mkDerivation rec {
  name = "mvd-tool-${version}";
  version = "1.1";
  
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5];

  src = fetchgit {
    url = "https://github.com/BlueBrain/MVDTool.git";
    rev = "782bee8a9ecd9872df12001e6e6fc585ea56ec63";
    sha256 = "0lm46sqf5yrcjip43ww9lrp4q50q9hghis6l7k066p7l6inh8a11";
  };
  
  cmakeFlags="-DUNIT_TESTS=TRUE";   

  enableParallelBuilding = true;
  
  doCheck = true;
  
  checkTarget = "test";

  propagatedBuildInputs = [ highfive ];
  
}


