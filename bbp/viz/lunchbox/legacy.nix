{ stdenv
, boost
, fetchgit
, cmake
, servus
, pkgconfig
, doxygen
}:

stdenv.mkDerivation rec {
  name = "lunchbox";
  version = "2.16.0-legacy";
  buildInputs = [ stdenv boost pkgconfig servus cmake doxygen];

  src = fetchgit {
    url = "https://github.com/Eyescale/Lunchbox.git";
    rev = "1a96478";
    sha256 = "0yrdmggcncxahd47m8jvl59c0zcwyydkmdc17rn7npjs369w1y75";
  };


  cmakeFlags = [ "-DCOMMON_DISABLE_WERROR=TRUE" ];

  propagatedBuildInputs = [ boost servus ];


  enableParallelBuilding = true;

  doCheck = true;

  checkPhase = ''
	export LD_LIBRARY_PATH=''${PWD}/lib/:''${LD_LIBRARY_PATH}
	# disable perf -> too much time and memory
	# disable thread -> will fail when executed on machine with low resource
	ctest -V -E "(perf|Thread|thread)"
  '';

}
