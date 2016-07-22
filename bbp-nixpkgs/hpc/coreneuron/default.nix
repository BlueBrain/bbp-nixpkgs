{ stdenv, fetchgitPrivate, perl, cmake, boost, pkgconfig, mpiRuntime, mod2c, mods-src}:

stdenv.mkDerivation rec {
  name = "coreneuron-${version}";
  version = "0.8.1";
  
  buildInputs = [ stdenv perl cmake boost pkgconfig mpiRuntime mod2c];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/coreneuron";
    rev =  "cd60ce45ffb7676dbb549c91e35d28f7a6019889";
    sha256 = "1sa1kribrzc14jcsizwc7hf8g35zvvvdb2kyb2zh3cli50pxpw6w";   
  };



#   patchPhase=''
#		mkdir -p coreneuron/mech;
#		cp -r ${mods-src} coreneuron/mech/neurodamus;
#		chmod -R 755 coreneuron/mech/neurodamus;
#	'';
 
  
}



