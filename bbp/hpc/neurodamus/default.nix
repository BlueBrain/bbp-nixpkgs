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
    rev = "e38ea3b7b94ef73e538d0c6da59b827f24f40c55";
    sha256 = "1ml6dkmz0cyy06f2kzl4xhy0mn57riqjdhc00p6dhi3r6b9gq5j0";
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


