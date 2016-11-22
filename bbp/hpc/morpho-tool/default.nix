{ stdenv, fetchgitPrivate, pkgconfig, boost, cmake, zlib, hdf5, highfive }:

stdenv.mkDerivation rec {
  name = "morpho-tool-${version}";
  version = "0.1";
  
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/hpc/morpho-tool";
    rev = "03b5c1b5714287dfba6dd89a4323ff651006440d";
    sha256 = "0hnynzkg3q43iacjab806sq2klhn6bhisrx9849ks7lpg8wbvbga";
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


