{ stdenv, fetchurl, boost, lunchbox, brion, vmmlib, servus, cmake, bbp-cmake, mpich2, pkgconfig, python, hdf5, doxygen }:

stdenv.mkDerivation rec {
  name = "bbpsdk-0.22.0.0DEV";
  buildInputs = [ stdenv pkgconfig boost brion vmmlib servus cmake bbp-cmake mpich2 lunchbox python hdf5 doxygen];

  src = fetchurl {
    url = "https://owncloud.adev.name/public.php?service=files&t=bf58a72f503d6637b165466de93c93ef&download";
    name = "bbpsdk-0.22.0.tar.gz";
    curlOpts = "-k";
    sha256 = "fd5d9cf27fde01b836e961246a491699fa8e33eb2e6a2292d818fb0dbec3333d";
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

