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
, syntool-phdf5
, thrift
, zstd }:

stdenv.mkDerivation rec {
  name = "parquet-converters-${version}";
  version = "0.1.0";

  buildInputs = [ arrow boost highfive-phdf5 mpiRuntime parquet-cpp phdf5 snappy syntool-phdf5 thrift zstd ];

  nativeBuildInputs = [
    cmake
  ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/ParquetConverters";
    rev = "82b5d8d287f68c8c8bd6868846a884b6d7e4e532";
    sha256 = "02il97zs614khd8mlgczgi2vzgy5y76rs3674gpl8spx7cpwhv3h";
  };

  cmakeFlags = [
    "-DLIB_SUFFIX="
    "-DNEURONPARQUET_USE_MPI=ON"
  ];

  enableParallelBuilding = true;

  outputs = [ "out" ];

  preConfigure = "
    export CC=mpicc
    export CXX=mpic++
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
