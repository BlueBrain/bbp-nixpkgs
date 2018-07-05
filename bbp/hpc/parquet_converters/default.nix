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
  version = "0.1.1";

  buildInputs = [ arrow boost highfive-phdf5 mpiRuntime parquet-cpp phdf5 snappy syntool-phdf5 thrift zstd ];

  nativeBuildInputs = [
    cmake
  ];

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/ParquetConverters";
    rev = "f37f628cf91e3cb9cbf322cab369c5a80b965796";
    sha256 = "1qq4l0lf8chk04pasmmzyqaivx2n94yaxq2bb5sdnj1yswr6j5lh";
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
