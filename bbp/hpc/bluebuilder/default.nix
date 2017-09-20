{ stdenv,
config,
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
    url = config.bbp_git_ssh + "/building/BlueBuilder";
    rev = "e304808bd291803a8eab57b61a8cb72d85374006";
    sha256 = "1fx76ivl81x27sh9d23s3d3grh7cmv73a23gg0lplz451p97956n";
  };

  isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
        then builtins.getAttr "isBlueGene" stdenv else false;

  cmakeFlags="-DBoost_USE_STATIC_LIBS=${if isBGQ then "TRUE" else "FALSE"}";

  enableParallelBuilding = true;
}


