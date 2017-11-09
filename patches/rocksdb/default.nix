{ stdenv, fetchFromGitHub, fixDarwinDylibNames

# Optional Arguments
, snappy ? null, google-gflags ? null, zlib ? null, bzip2 ? null, lz4 ? null
, numactl ? null

# Malloc implementation
, jemalloc ? null, gperftools ? null

, enableLite ? false
}:

let
  malloc = if jemalloc != null then jemalloc else gperftools;
in
stdenv.mkDerivation rec {
  name = "rocksdb-${version}";
  version = "5.8";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "rocksdb";
    rev = "v${version}";
    sha256 = "1q0qfj4lh0f4a96gxcyvz9sa2pqg9pqmw6mm5inygqmpyh1pfcv6";
  };

  buildInputs = [ snappy google-gflags zlib bzip2 lz4 malloc fixDarwinDylibNames ];

  postPatch = ''
    # Hack to fix typos
    sed -i 's,#inlcude,#include,g' build_tools/build_detect_platform
  '';

  # Environment vars used for building certain configurations
  PORTABLE = "1";
  USE_SSE = "1";
  CMAKE_CXX_FLAGS = "-std=gnu++11";
  JEMALLOC_LIB = stdenv.lib.optionalString (malloc == jemalloc) "-ljemalloc";

  ${if enableLite then "LIBNAME" else null} = "librocksdb_lite";
  ${if enableLite then "CXXFLAGS" else null} = "-DROCKSDB_LITE=1";

  buildFlags = [
    "DEBUG_LEVEL=0"
    "shared_lib"
    "static_lib"
  ];

  installFlags = [
    "INSTALL_PATH=\${out}"
    "DEBUG_LEVEL=0"
    "install-shared"
    "install-static"
  ];

  postInstall = ''
    # Might eventually remove this when we are confident in the build process
    echo "BUILD CONFIGURATION FOR SANITY CHECKING"
    cat make_config.mk
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://rocksdb.org;
    description = "A library that provides an embeddable, persistent key-value store for fast storage";
    license = licenses.bsd3;
    platforms = platforms.allBut [ "i686-linux" ];
    maintainers = with maintainers; [ wkennington ];
  };
}
