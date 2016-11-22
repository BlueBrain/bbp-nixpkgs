{ stdenv, fetchgit, pkgconfig, boost, cmake, zlib, hdf5, highfive }:

stdenv.mkDerivation rec {
  name = "mvd-tool-${version}";
  version = "1.1";
  
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5];

  src = fetchgit {
    url = "https://github.com/BlueBrain/MVDTool.git";
    rev = "2ce29f258cf47893885feec3450366bb4e5b08b0";
    sha256 = "0hii11avf7c3cx0j65fvgmwjy6igv7ndcjp7wm6hbq5ixvwb0mca";
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


