{ stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  name = "cereal-${version}";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "USCiLab";
    repo = "cereal";
    rev = "51cbda5f30e56c801c07fe3d3aba5d7fb9e6cca4";
    sha256 = "1ckr8r03ggg5pyzg8yw40d5ssq40h5najvyqlnxc85fxxp8rnrx4";
  };
  passthru = {
    src = src;
  };

  # This is a C++ header-only library. The option below disables
  # compilation and execution of unit-tests
  cmakeFlags = [
    "-DJUST_INSTALL_CEREAL:BOOL=ON"
  ];
  nativeBuildInputs = [ cmake ];

  meta = {
    description = "A C++11 library for serialization";
    longDescription = ''
      cereal is a header-only C++11 serialization library.
      cereal takes arbitrary data types and reversibly turns them into
      different representations, such as compact binary encodings, XML,
      or JSON. cereal was designed to be fast, light-weight, and easy
      to extend - it has no external dependencies and can be easily
      bundled with other code or used standalone.
    '';
    platforms = stdenv.lib.platforms.all;
    homepage = "http://uscilab.github.com/cereal";
  };
}
