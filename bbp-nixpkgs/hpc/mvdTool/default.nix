{ stdenv, fetchgit, pkgconfig, boost, cmake, zlib, hdf5 }:

stdenv.mkDerivation rec {
  name = "mvdTool-1.0";
  buildInputs = [ stdenv pkgconfig boost zlib cmake hdf5];

  src = fetchgit {
    url = "https://github.com/BlueBrain/MVDTool.git";
    rev = "27be7fdb39b09c32ecc43ee12e3f9fb12aecfadd";
    sha256 = "186i7sgys002p82h6xi8j86v6k3zz7d4ljnmqj47rlcwpqb6i0jz";
  };
  
  cmakeFlags="-DUNIT_TESTS=TRUE";   

  enableParallelBuilding = true;
  
  doCheck = true;
  
  checkTarget = "test";
  
}


