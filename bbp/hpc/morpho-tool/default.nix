{ stdenv, fetchgitPrivate, pkgconfig, boost, cmake, zlib, hdf5, highfive }:

stdenv.mkDerivation rec {
  name = "morpho-tool-${version}";
  version = "0.1-201611";
  
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/hpc/morpho-tool";
    rev = "10c7fc895be10477ef0f346988f3c81a15a6edf0";
    sha256 = "1zksixg8r3362n7r6xmy67jayvyggl54ds6cyq4hcpwxhn6wjm07";
  };
  
  cmakeFlags=[ 
			   "-DUNIT_TESTS=ON"
			   "-DMORPHO_INSTALL_HIGHFIVE=OFF"
			 ];   

  enableParallelBuilding = true;
  
  doCheck = true;
  
  checkTarget = "test";

  propagatedBuildInputs = [ highfive ];
  
}


