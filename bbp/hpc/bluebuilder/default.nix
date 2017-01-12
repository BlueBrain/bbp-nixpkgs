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
  name = "bluebuilder-${version}";
  version = "1.2.1-201701";
  buildInputs = [ stdenv pkgconfig boost hpctools hdf5 zlib cmake mpiRuntime libxml2];

  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/building/BlueBuilder";
    rev = "9c5ac2fe7ff87c2e5a45f18508d3c92095fa856c";
    sha256 = "1l3plrxirh7zsix82hl1wsy6r0zcm4199nqvzw9m6ds4vl16s0n2";
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


