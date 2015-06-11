{ stdenv, fetchgitPrivate, boost, lunchbox, brion, vmmlib, servus, cmake, bbp-cmake, mpich2, pkgconfig, python, hdf5, doxygen }:

stdenv.mkDerivation rec {
  name = "bbpsdk-0.22.0.0DEV";
  buildInputs = [ stdenv pkgconfig boost brion vmmlib servus cmake bbp-cmake mpich2 lunchbox python hdf5 doxygen];

  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/common/BBPSDK";
    rev= "dbba3f6f1cc175b5d8da0376a97199e01e805573";
    sha256 = "1218ymr4iylnipgqpdi4w1dwssrlfgyb4pn9c1anbc4gg33i468a";
  };

# disable Java bindings
# disable git external maddness
# disable functional tests
  patchPhase= ''
	ln -s ${bbp-cmake}/share/bbp-cmake/Common CMake/common &&
	rm -rf \.gitsubprojects &&
	rm -rf \.gitexternals &&
	sed -i 's@message(FATAL_ERROR@message(STATUS@g' binds/CMakeLists.txt &&
	sed -i 's@add_subdirectory(tests)@@g' CMakeLists.txt
  '';
  

  enableParallelBuilding = true;
}

