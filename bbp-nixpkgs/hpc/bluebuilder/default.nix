{ stdenv,
fetchgitPrivate,
pkgconfig,
boost, 
hpctools, 
libxml2, 
hdf5,
zlib,
cmake, 
cmake-external,
mpiRuntime, 
}:

stdenv.mkDerivation rec {
  name = "bluebuilder-1.2.1-DEV";
  buildInputs = [ stdenv pkgconfig boost hpctools hdf5 zlib cmake cmake-external mpiRuntime libxml2];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/building/BlueBuilder";
    rev = "731bf5694aba9cb433273beb9009c5fbe50ee3fa";
    sha256 = "0z7wn9mylxyv1522qwmgqnz933xym7wd7zqs6jqvp1ydgbgf13i2";
    deepClone = true;
  };
  
  cmakeFlags="-DBoost_USE_STATIC_LIBS=FALSE";  
  
  patchPhase= ''
    sed -i 's@set(Boost_USE_STATIC_LIBS ON)@set(Boost_USE_STATIC_LIBS OFF)@g' CMakeLists.txt
    '';    

  enableParallelBuilding = true;
}


