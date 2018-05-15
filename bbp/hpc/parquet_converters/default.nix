{ stdenv
, arrow
, boost
, cmake
, config
, fetchgitPrivate
, highfive-phdf5
, mpiRuntime
, parquet-cpp
, phdf5
, snappy
, syntool
, thrift
, zstd }:

stdenv.mkDerivation rec {
  name = "parquet-converters-${version}";
  version = "0.1.0";

  buildInputs = [ arrow boost highfive-phdf5 mpiRuntime parquet-cpp phdf5 snappy syntool thrift zstd ];

  nativeBuildInputs = [
    cmake
  ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/Functionalizer";
    rev = "ce633399af9ccd38ecc65f6ef72048e5c62bf359";
    sha256 = "0vk5lf46fj7br9v4kr5y4aj0z2ilj2ph8dc3m75zkmdiwgyv3a2r";
  };

  cmakeFlags = [
    "-DLIB_SUFFIX="
  ];

  enableParallelBuilding = true;

  outputs = [ "out" ];

  preConfigure = "
    export CC=mpicc
    export CXX=mpic++
    cd neuron_parquet
  ";

  meta = {
    description = "Convert touches and neurons between different formats";
    platforms = stdenv.lib.platforms.unix;
    homepage = "https://bbpcode.epfl.ch/code/#/admin/projects/building/Functionalizer";
    repository = "ssh://bbpcode.epfl.ch/building/Functionalizer";
    license = {
      fullName = "Copyright 2018, Blue Brain Project";
    };
    maintainers = [
      config.maintainers.ferdonline
      config.maintainers.matz-e
    ];
  };
}
