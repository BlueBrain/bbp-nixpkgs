{ stdenv, fetchgitPrivate, perl, cmake, boost, pkgconfig, mpiRuntime, mod2c, mods-src}:

stdenv.mkDerivation rec {
  name = "coreneuron-${version}";
  version = "0.8.1-201608";
  
  buildInputs = [ stdenv perl cmake boost pkgconfig mpiRuntime mod2c];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/coreneuron";
    rev =  "06c9f07bb12d6f0d60da1eb64025d183e9c205d3";
    sha256 = "10frfgjgfarbrbwfz4h9jiwycvh8crk441wwdafycdhd069wcq93";   
  };



#   patchPhase=''
#		mkdir -p coreneuron/mech;
#		cp -r ${mods-src} coreneuron/mech/neurodamus;
#		chmod -R 755 coreneuron/mech/neurodamus;
#	'';
 
  
}



