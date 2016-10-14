{ stdenv, fetchgitPrivate, pkgconfig, boost, cmake, zlib, hdf5, highfive }:

stdenv.mkDerivation rec {
  name = "morpho-tool-${version}";
  version = "0.1";
  
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/hpc/morpho-tool";
    rev = "63526730427ca51e1e2dd73564996a8e3042011f";
    sha256 = "1zazhf9878gh00f689yaac9jyalnz589b7cd4p50a0p5yxv21lvf";
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


