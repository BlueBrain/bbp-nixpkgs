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
  version = "1.8.4-201711";
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
    rev = "92d08e5dccdc4f3fbe4242bc9e5b00663e28cb99";
    sha256 = "1ycyb07g0jnibmpcddj2j14p9bg7dxcy5m02avcy20dklgwqhb66";
  };

  cmakeFlags= [ "-DCOMMON_DISABLE_WERROR=TRUE" ];

  enableParallelBuilding = true;
}
