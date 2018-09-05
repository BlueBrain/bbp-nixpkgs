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
, synapsetool-phdf5
, thrift
, zstd }:

stdenv.mkDerivation rec {
  name = "parquet-converters-${version}";
  version = "0.1.2";

  buildInputs = [ arrow boost highfive-phdf5 mpiRuntime parquet-cpp phdf5 snappy synapsetool-phdf5 thrift zstd ];

  nativeBuildInputs = [
    cmake
  ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/ParquetConverters";
    rev = "281b620f4bd70e017d1b00b513c0a9393ca381d8";
    sha256 = "115i5swmy2577b9fkzc29qr5dxwprhnbwsk210dyp73cnzzxnavh";
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
