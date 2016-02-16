{ stdenv
, fetchgitPrivate
, cmake
, cmake-external
, pkgconfig
, hdf5
, mpiRuntime
, zlib
, ncurses
, bluron
, reportinglib}:

stdenv.mkDerivation rec {
  name = "neurodamus-1.8.1-stable";
  buildInputs = [ stdenv cmake cmake-external pkgconfig hdf5 ncurses zlib mpiRuntime bluron reportinglib];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/neurodamus/bbp";
    rev = "bdd1cbe39b80d75a7da9109c3678dc883d5a4e4e";
    sha256 = "1fl9124fdnkgam1j4jnh0pm756qvdsmsbd817bbpmgxrfnv0r0yx";
    deepClone = true;
  };
  
 
    cmakeFlags="-DBluron_PREFIX_DIR=${bluron}";

  passthru = { sources = src; };
}


