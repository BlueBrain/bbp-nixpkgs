{ stdenv, fetchgitPrivate, pkgconfig, boost, cmake, zlib, hdf5, highfive, cgal, gmp, mpfr }:

stdenv.mkDerivation rec {
  name = "morpho-tool-${version}";
  version = "0.1-201701";
  
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5 cgal gmp mpfr ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/hpc/morpho-tool";
    rev = "49c795d0c0c4319129c8fe10b7338727263c5cd3";
    sha256 = "1xknvcd7ggfcxs1451442gkdmkbl1l0s78smch6zg2s0qa0qlicq";
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


