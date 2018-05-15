{
  buildEnv,
  cmake,
  boost,
  zlib,
  snappy,
  rapidjson,
  flatbuffers,
  zstd,
  fetchFromGitHub,
  stdenv
}:

let 
	# create an environment where all dependencies are under a single path
	# to compensate apache build system weakness
	arrow_env = buildEnv {
		name = "arrow_build_env";
		paths = [ rapidjson flatbuffers zstd ] ++ zlib.all ++ snappy.all ;

	};
in
stdenv.mkDerivation rec {
  name = "arrow-${version}";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "arrow";
    rev = "apache-arrow-${version}";
    sha256 = "0ggbbvmfwn1bqv8f4j4xsj4s22l9cnx94b2vj4ybr295w0d7ixp5";
  };

  preConfigure = ''
	cd cpp 
  '';

  meta = {
    description = "Apache arrow project";
    longDescription = "";
    platforms = stdenv.lib.platforms.all;
  };

  buildInputs = [
    arrow_env
    boost
    cmake
  ];

  cmakeFlags = [
	"-DARROW_USE_SSE=ON"
	"-DARROW_BUILD_TESTS=OFF"
	"-DARROW_WITH_BROTLI=OFF"
	"-DARROW_WITH_LZ4=OFF"
	"-DZLIB_HOME=${arrow_env}"
	"-DSNAPPY_HOME=${arrow_env}"
	"-DRAPIDJSON_HOME=${arrow_env}"
	"-DFLATBUFFERS_HOME=${arrow_env}"
	"-DZSTD_HOME=${arrow_env}"
  ];
}
