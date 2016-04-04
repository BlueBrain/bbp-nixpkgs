{ stdenv,
fetchgitExternal,
pkgconfig,
boost, 
hpctools, 
libxml2, 
hdf5,
zlib,
cmake, 
mpiRuntime, 
}:

stdenv.mkDerivation rec {
  name = "bluebuilder-1.2.1";
  buildInputs = [ stdenv pkgconfig boost hpctools hdf5 zlib cmake mpiRuntime libxml2];

  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/building/BlueBuilder";
    rev = "731bf5694aba9cb433273beb9009c5fbe50ee3fa";
    sha256 = "1vis3s3bbhd2836mch3cb29kr6ws8dpyxy7br1zc9zrxnlypzjx2";
  };
  
  isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
        then builtins.getAttr "isBlueGene" stdenv else false;
  
  cmakeFlags="-DBoost_USE_STATIC_LIBS=${if isBGQ then "TRUE" else "FALSE"}";  
  
  patchPhase= if isBGQ == false then
    ''
    sed -i 's@set(Boost_USE_STATIC_LIBS ON)@set(Boost_USE_STATIC_LIBS OFF)@g' CMakeLists.txt
    ''
    else '''';    

  enableParallelBuilding = true;
}


