{ stdenv, fetchgit, pkgconfig, boost, cmake, zlib, hdf5 }:

stdenv.mkDerivation rec {
  name = "mvdTool-1.0-DEV";
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5];

  src = fetchgit {
    url = "https://github.com/BlueBrain/MVDTool.git";
    rev = "6a09a0c1170641b9c891ec61e99eba842aaf1bb8";
    sha256 = "1jwgncvm76c7q7h90cncxwwf0lz9ilmy5hzfpamwmqhylys9ql17";
  };
  
  cmakeFlags="-DUNIT_TESTS=TRUE";   

  enableParallelBuilding = true;
  
  doCheck = true;
  
  checkTarget = "test";
  
}


