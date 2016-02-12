{ stdenv, fetchgit, cmake, cmake-external, boost, pkgconfig, doxygen }:

stdenv.mkDerivation rec {
  name = "servus-1.1.0-stable";
  buildInputs = [ stdenv pkgconfig boost cmake cmake-external doxygen];

  src = fetchgit {
    url = "https://github.com/HBPVIS/Servus.git";
    
    rev = "0a5c5e4aeb6479e4ed6346b0aa9197a14d38afa4";
    sha256 = "1rpx3jcjmw4gw9f0iiwshdvk0qjbfmxifi20klrjim5xhys64xrn";
    deepClone = true;
  };
  

  enableParallelBuilding = true;
}




