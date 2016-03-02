{ stdenv, fetchgitExternal, perl, cmake, boost, pkgconfig, mpiRuntime, mod2c, mods-src}:

stdenv.mkDerivation rec {
  name = "coreneuron-0.7.0";
  buildInputs = [ stdenv perl cmake boost pkgconfig mpiRuntime mod2c];


  src = fetchgitExternal {
    url = "ssh://bbpcode.epfl.ch/sim/coreneuron";
    rev =  "a7231d5aa7725b87c772b690c0f96b0404319414";
    sha256 = "0618w46ximr1cp02w19fdvqnqlm37456f8lg3iqik7lridzxck2b";   
  };



#   patchPhase=''
#		mkdir -p coreneuron/mech;
#		cp -r ${mods-src} coreneuron/mech/neurodamus;
#		chmod -R 755 coreneuron/mech/neurodamus;
#	'';
 
  
}



