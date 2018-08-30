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
  version = "1.16.0-dev201806";
  buildInputs = [ stdenv boost pkgconfig servus cmake doxygen];

  src = fetchgit {
    url = "https://github.com/Eyescale/Lunchbox.git";
    rev = "dd85ecc90ecac5cc782c135cec7b356c01870388";
    sha256 = "13zr48zqqmd6barqr7klq8sy7nhzbaa2qzqziqw83idl89avn4sw";
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
