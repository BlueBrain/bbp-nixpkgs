{
  boost,
  config,
  cmake,
  fetchFromGitHub,
  hdf5,
  pandoc ? null,
  stdenv,
  zlib,
}:

stdenv.mkDerivation rec {
  name = "highfive-${version}";
  version = "2.0-dev201809";

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "HighFive";
    rev = "8db7f3c094b97002e177b610c98262fc1c5c78f8";
    sha256 = "0ibn04klyim31ksmmfvdiiirqzngkmpl7cnjr4z7mmcy3d1yglqc";
  };

  buildInputs = [
    boost
    cmake
    hdf5
    stdenv
    zlib
  ] ++ stdenv.lib.optional (pandoc != null) pandoc;

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DUNIT_TESTS:BOOL=TRUE"
  ] ++ stdenv.lib.optional (pandoc != null) "-DHIGH_FIVE_DOCUMENTATION:BOOL=TRUE";

  doCheck = true;

  checkTarget = "test";

  outputs = [ "out" ] ++ stdenv.lib.optional (pandoc != null) "doc";

  propagatedBuildInputs = [ hdf5 ];

  meta = {
    description = "Header-only C++ HDF5 interface";
    longDescription = ''
      HighFive is a modern C++/C++11 friendly interface for libhdf5.
      HighFive supports STL vector/string, Boost::UBLAS and Boost::Multi-array.
      It handles C++ from/to HDF5 automatic type mapping. HighFive does not
      require an additional library and supports both HDF5 thread safety and
      Parallel HDF5 (contrary to the official hdf5 cpp).
    '';
    platforms = stdenv.lib.platforms.all;
    homepage = https://github.com/BlueBrain/HighFive;
    license = stdenv.lib.licenses.boost;
    maintainers = [
      config.maintainers.adevress
    ];
  };

}
