{
  boost,
  cmake,
  fetchFromGitHub,
  stdenv
}:

stdenv.mkDerivation rec {
  name = "yaml-cpp-${version}";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "jbeder";
    repo = "yaml-cpp";
    rev = "yaml-cpp-${version}";
    sha256 = "0qr286q8mwbr4cxz0y0rf045zc071qh3cb804by6w1ydlqciih8a";
  };

  passthru = {
    src = src;
  };

  meta = {
    description = "A YAML parser and emitter in C++";
    longDescription = "";
    platforms = stdenv.lib.platforms.all;
    homepage = "https://github.com/jbeder/yaml-cpp";
    license = stdenv.lib.licenses.mit;
  };

  buildInputs = [
    boost
    cmake
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS:BOOL=ON"
  ];
}