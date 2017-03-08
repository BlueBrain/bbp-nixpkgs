{ stdenv, fetchgitPrivate, pkgconfig, boost, cmake, zlib, hdf5, highfive, cgal, gmp, mpfr }:

stdenv.mkDerivation rec {
  name = "morpho-tool-${version}";
  version = "0.1-201701";
  
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5 cgal gmp mpfr ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/hpc/morpho-tool";
    rev = "c66db6bb7ee9fd7e1d51d20c12b50ae2c8536218";
    sha256 = "07vxcv4q074fpah7m5k0wa2hpz27xa85rnhxhqn2kcbwvjq79lcp";
  };
  
  cmakeFlags=[ 
			   "-DUNIT_TESTS=ON"
			   "-DMORPHO_INSTALL_HIGHFIVE=OFF"
               "-DENABLE_MESHER_CGAL=ON"
			 ];   

  enableParallelBuilding = true;
  
  doCheck = true;
  
  checkPhase = ''
    export LD_LIBRARY_PATH=$PWD/src/morpho:$LD_LIBRARY_PATH;
    ctest -V
  '';

  propagatedBuildInputs = [ highfive ];
  
}


