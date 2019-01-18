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
  version = "latest";
  buildInputs = [ stdenv boost pkgconfig servus cmake doxygen];

  src = fetchgit {
    url = "https://github.com/Eyescale/Lunchbox.git";
    rev = "cd4e724d98a71bfa101b4c8088c856f3e4072b2b";
    sha256 = "104mvn9grxh9y7qrzd0jpgdlfbhffv9vppwix9wpbsmywlvfibbv";
  };


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
