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
  version = "1.4-dev201710";

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "HighFive";
    rev = "fce248203ca88c412fb32d5cb862628352d0bfe5";
    sha256 = "00wkkaplj2506zdci25axqvgs5lfnm45hm7ps6l4f7bmk8r39zl6";
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
