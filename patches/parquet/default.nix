{
  arrow,
  boost,
  cmake,
  fetchFromGitHub,
  stdenv,
  thrift
}:

stdenv.mkDerivation rec {
  name = "parquet-${version}";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "parquet-cpp";
    rev = "apache-parquet-cpp-${version}";
    sha256 = "1xp1aq0vbj2aynwl3izfibrxi69aj2awmg7mcbp7d40j2kgpxfpz";
  };

  enableParallelBuilding = true;

  buildInputs = [
    boost
    cmake
    arrow
    thrift
  ];

  cmakeFlags = [
	"-DTHRIFT_HOME=${thrift}"
	"-DARROW_HOME=${arrow}"
	"-DPARQUET_USE_SSE=OFF"
#       "-DPARQUET_BUILD_TESTS=
  ];
}
