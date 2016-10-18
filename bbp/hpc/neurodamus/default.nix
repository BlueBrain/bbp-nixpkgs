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
  name = "neurodamus-${version}";
  version = "1.9.0-201609";
  buildInputs = [ stdenv which cmake pkgconfig hdf5 ncurses zlib mpiRuntime reportinglib nrnEnv ];


  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/sim/neurodamus/bbp";
    rev = "9743218314bb6f8b245fc60893d508f4ecacd402";
    sha256 = "0iyiqqicma93l2risnn2xh5yyqz3sqydhidd3j13yvb9fn8w4kas";
  };
  

  isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
			then builtins.getAttr "isBlueGene" stdenv else false;
 
  # missing -sqmp for symbols from reportinglib
  # precify the neuron path manually
  cmakeFlags=''${if isBGQ then ''-DADD_LIBS="-qsmp"'' else ''''} -DBluron_PREFIX_DIR=${nrnEnv}/'';

 passthru = {
	src = src;
 }; 

  MODLUNIT="${nrnEnv}/share/nrn/lib/nrnunits.lib";
  
  # we need to patch the last line of special on not-BGQ paltforms
  # current one is not able to work outside of build directory 
  # and reference statically this one
  postInstall = if isBGQ == false then 
''
## rename accordingly special mech path
grep -v "\-dll" $out/bin/special > ./special.tmp
cp ./special.tmp $out/bin/special
echo " \"\''${NRNIV}\" -dll \"$out/lib/libnrnmech.so\" \"\$@\" " >> $out/bin/special
## nrn mech is not installed properly by cmake 
mkdir -p $out/lib
cp lib/*/*/.libs/*.so* $out/lib/
'' 
  else
'' '';

  propagatedBuildInputs = [ which hdf5 reportinglib ];

}


