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
  name = "converters-${version}";
  version = "0.1.0";

  buildInputs = [ arrow boost highfive-phdf5 mpiRuntime parquet-cpp phdf5 snappy syntool thrift zstd ];

  nativeBuildInputs = [
    cmake
  ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/Functionalizer";
    rev = "096ff187f25683219b8c372c38b07888f6d89f70";
    sha256 = "0pm07c752nh7wjxagipk0sfmlir2b2jscwgs4bm9r89rnjdwfzg4";
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
      fullName = "Copyright 2012, Blue Brain Project";
    };
    maintainers = [
      config.maintainers.ferdonline
      config.maintainers.matz-e
    ];
  };
}
