{ stdenv
, which
, fetchgitExternal
, cmake
, pkgconfig
, hdf5
, mpiRuntime
, zlib
, ncurses
, reportinglib
, nrnEnv
}:

stdenv.mkDerivation rec {
  name = "neurodamus-1.9.0";
  buildInputs = [ stdenv which cmake pkgconfig hdf5 ncurses zlib mpiRuntime reportinglib nrnEnv ];


  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/sim/neurodamus/bbp";
    rev = "3de16b8e4e5ae3cc2080afc03ecdb93a9ed597c5";
    sha256 = "05wzlq15fvsvjp3xhkzjwc09gw3nrl9s4lq3rri3qsv41dm3hdl4";
  };
  

  isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
			then builtins.getAttr "isBlueGene" stdenv else false;
 
  # missing -sqmp for symbols from reportinglib
  # precify the neuron path manually
  cmakeFlags=''${if isBGQ then ''-DADD_LIBS="-qsmp"'' else ''''} -DBluron_PREFIX_DIR=${nrnEnv}/'';


  MODLUNIT="${nrnEnv}/share/nrn/lib/nrnunits.lib";





}


