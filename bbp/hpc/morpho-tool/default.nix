{ stdenv, fetchgitPrivate, pkgconfig, boost, cmake, zlib, hdf5, highfive, cgal, gmp, mpfr }:

stdenv.mkDerivation rec {
  name = "morpho-tool-${version}";
  version = "0.1-201701";
  
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5 cgal gmp mpfr ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/hpc/morpho-tool";
    rev = "bc695eb2f161da8174f8de4bed1c421610bd0ce8";
    sha256 = "093cw108mfh0z9kk92315j8i8rpb64z8ff963kvhjvp3bz29x8p2";
  };
  
  cmakeFlags=[ 
			   "-DUNIT_TESTS=ON"
			   "-DMORPHO_INSTALL_HIGHFIVE=OFF"
			 ];   

  enableParallelBuilding = true;
  
  doCheck = false;
  
  checkTarget = "test";

  propagatedBuildInputs = [ highfive ];
  
}


