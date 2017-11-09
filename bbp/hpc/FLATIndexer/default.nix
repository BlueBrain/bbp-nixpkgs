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
  version = "1.8.3-201710";
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
    rev = "0b3a7e16c6371440d2118f904949bd0a2f33e8c5";
    sha256 = "0zn0x9gknc2n9hzk9jrifgppdd9gbmrw8qd199l69hm2qxjak206";
  };

  cmakeFlags= [ "-DCOMMON_DISABLE_WERROR=TRUE" ];

  enableParallelBuilding = true;
}
