{ stdenv, fetchgitPrivate, pkgconfig, boost, cmake38, zlib, hdf5, highfive, cgal, gmp, mpfr }:

stdenv.mkDerivation rec {
  name = "morpho-tool-${version}";
  version = "0.2-201704";

  buildInputs = [ stdenv pkgconfig boost zlib cmake38 hdf5 cgal gmp mpfr ];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/hpc/morpho-tool";
    rev = "047cf3c5a47ac486b7e660e0630b50203c9ec6fc";
    sha256 = "0w2gyanfsidfysfz06djssflha9agzniagynqcpfch6jxglibn92";
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


