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
                version = "1.16.0-dev201708";
                rev = "80c14e04666aeb64eb69c605663b3065252339c5";
                sha256 = "0cgb6jckbkjh50ds275zfwp5lpf2nfd4aq7s9qdp76fib18fbbkn";
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



