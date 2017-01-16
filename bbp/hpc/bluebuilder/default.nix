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
    rev = "e304808bd291803a8eab57b61a8cb72d85374006";
    sha256 = "1c8k0s2g0p4b7myh56rq9j8bg1fjjgsdhszbfnsdfcx4nkm9fxkn";
  };
  
  isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
        then builtins.getAttr "isBlueGene" stdenv else false;
  
  cmakeFlags="-DBoost_USE_STATIC_LIBS=${if isBGQ then "TRUE" else "FALSE"}";  
  
  enableParallelBuilding = true;
}


