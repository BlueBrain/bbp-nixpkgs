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
  name = "neurodamus-1.9.0";
  buildInputs = [ stdenv cmake pkgconfig hdf5 ncurses zlib mpiRuntime bluron reportinglib];


  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/sim/neurodamus/bbp";
    rev = "3de16b8e4e5ae3cc2080afc03ecdb93a9ed597c5";
    sha256 = "05wzlq15fvsvjp3xhkzjwc09gw3nrl9s4lq3rri3qsv41dm3hdl4";
  };
  
 
  cmakeFlags="-DBluron_PREFIX_DIR=${bluron}";

  passthru = { sources = src; };
}


