{ stdenv
, boost
, fetchgit
, cmake
, servus
, pkgconfig
, doxygen 
, legacyVersion ? false
}:


let
        legacy-info = {
                version = "2.16.0-legacy";
                rev = "1a96478";
                sha256 = "0yrdmggcncxahd47m8jvl59c0zcwyydkmdc17rn7npjs369w1y75";
        };

        last-info = {
                version = "1.16.0-dev201806";
                rev = "ab0c1e30f0deafaf5b0e97cf625cc7d2ceeb6e61";
                sha256 = "06089lzspvdpc0j17g1bjlw4f1i42j0kjxl76bqcpl2qklnmcs6b";
        };

        lunchbox-info = if (legacyVersion) then legacy-info else last-info;

in
stdenv.mkDerivation rec {
  name = "lunchbox";
  version = lunchbox-info.version;
  buildInputs = [ stdenv boost pkgconfig servus cmake doxygen];

  src = fetchgit {
    url = "https://github.com/Eyescale/Lunchbox.git";
    rev = lunchbox-info.rev;
    sha256 = lunchbox-info.sha256;
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



