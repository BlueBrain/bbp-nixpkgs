{ stdenv, fetchgitPrivate, pkgconfig, boost, cmake, zlib, hdf5, highfive, cgal, gmp, mpfr }:

stdenv.mkDerivation rec {
  name = "morpho-tool-${version}";
  version = "0.2-201704";
  
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5 cgal gmp mpfr ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/hpc/morpho-tool";
    rev = "cf732b041b6189002021b62891058c48df6a467b";
    sha256 = "0v5q49mwr7196v31a672h6q40hshx6nfcdfncir9kddq85wxa9p9";
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


