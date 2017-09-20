{ stdenv,
config,
fetchgitPrivate,
pkgconfig,
boost,
bbpsdk,
brion,
sparsehash,
lunchbox,
vmmlib,
servus,
cmake,
mpiRuntime,
zlib,
python,
numpy,
hdf5,
doxygen }:

stdenv.mkDerivation rec {
  name = "flatindexer-${version}";
  version = "1.8.3";
  buildInputs = [
    bbpsdk
    boost
    brion
    cmake
    doxygen
    hdf5
    lunchbox
    numpy
    pkgconfig
    python
    servus
    sparsehash
    stdenv
    vmmlib
    zlib
  ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/FLATIndex";
    rev = "1a6df17f6022af192be857343e39cc3b0d7691af";
    sha256 = "035vds9az6vpm25akc0qhgi427zzfgl3iyr6c73bbcj0r0hjnqzc";
  };

  cmakeFlags= [ "-DCOMMON_DISABLE_WERROR=TRUE" ];

  enableParallelBuilding = true;
}
