{ stdenv
, fetchgitExternal
, cmake
, pkgconfig
, hdf5
, mpiRuntime
, zlib
, ncurses
, bluron
, reportinglib}:

stdenv.mkDerivation rec {
  name = "neurodamus-1.8.1-stable";
  buildInputs = [ stdenv cmake pkgconfig hdf5 ncurses zlib mpiRuntime bluron reportinglib];


  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/sim/neurodamus/bbp";
    rev = "bdd1cbe39b80d75a7da9109c3678dc883d5a4e4e";
    sha256 = "0rld9jahm5asjwp51iy3b134c4d79plg156yizagvy598ff1dgza";
  };
  
 
  cmakeFlags="-DBluron_PREFIX_DIR=${bluron}";

  passthru = { sources = src; };
}


