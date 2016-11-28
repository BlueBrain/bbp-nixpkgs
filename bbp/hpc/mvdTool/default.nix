{ stdenv, fetchgit, pkgconfig, boost, cmake, zlib, hdf5, highfive }:

stdenv.mkDerivation rec {
  name = "mvd-tool-${version}";
  version = "1.2";
  
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5];

  src = fetchgit {
    url = "https://github.com/BlueBrain/MVDTool.git";
    rev = "c786dd41977bef10b0cf3e3668812d42e72fa131";
    sha256 = "0qzkrrbijbpihgw8334slsp824b5lfmaa2fzx8hiajalc5389wva";
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


