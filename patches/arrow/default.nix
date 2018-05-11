{
  cmake,
  boost,
  zlib,
  snappy,
  fetchFromGitHub,
  stdenv
}:

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
    zlib.all
    snappy.all
    boost
    cmake
  ];

  cmakeFlags = [
	"-DARROW_USE_SSE=ON"
	"-DARROW_BUILD_TESTS=OFF"
	"-DARROW_WITH_BROTLI=OFF"

  ];
}
