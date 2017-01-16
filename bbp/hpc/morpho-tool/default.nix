{ stdenv, fetchgitPrivate, pkgconfig, boost, cmake, zlib, hdf5, highfive, cgal, gmp, mpfr }:

stdenv.mkDerivation rec {
  name = "morpho-tool-${version}";
  version = "0.1-201611";
  
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5 cgal gmp mpfr ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/hpc/morpho-tool";
    rev = "9d2dfee6b2c446dbe18be899190347c469e25566";
    sha256 = "1s1k5bjyipz5vjchzhhjasdx6nkr6h0xvfmzjpxwzjdggp3smkwz";
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


