{
  boost,
  cmake,
  fetchFromGitHub,
  hdf5,
  pandoc? null,
  stdenv,
  zlib,
}:

stdenv.mkDerivation rec {
  name = "highfive-${version}";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "HighFive";
    rev = "476782bf94d8bf114df648756f2a5d3d110a25e9";
    sha256 = "1lnf8514p81y7c63avai697ydwx8c8bcbk0mix4p8j7cmm5y4fcw";
  };

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
}
