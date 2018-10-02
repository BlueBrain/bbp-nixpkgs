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
    rev = "3231f290be34ffd310785d846860e56fa39a6665";
    sha256 = "1v5rig3gghgp85rhi7yr870qdl78kzjdmkgzckgbly1c7mx7flx7";
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
