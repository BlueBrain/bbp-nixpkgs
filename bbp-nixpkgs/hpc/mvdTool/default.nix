{ stdenv, fetchgit, pkgconfig, boost, cmake, zlib, hdf5, highfive }:

stdenv.mkDerivation rec {
  name = "mvd-tool-${version}";
  version = "1.1";
  
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5];

  src = fetchgit {
    url = "https://github.com/BlueBrain/MVDTool.git";
    rev = "fa7523e24df0bd5e2db5997cdd666295693a8fc2";
    sha256 = "1fpjz9zfn5slfmdsa92zkxbkx7amziq8wa64ic49i22ccg19ymj5";
  };
  
  cmakeFlags=[ 
			   "-DUNIT_TESTS=ON"
			   "-DMVDTOOL_INSTALL_HIGHFIVE=OFF"
			 ];   

  enableParallelBuilding = true;
  
  doCheck = true;
  
  checkTarget = "test";

  propagatedBuildInputs = [ highfive ];
  
}


