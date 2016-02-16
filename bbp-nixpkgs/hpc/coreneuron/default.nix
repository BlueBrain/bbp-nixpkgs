{ stdenv, fetchgitPrivate, perl, cmake, boost, cmake-external, pkgconfig, mpiRuntime, mod2c, mods-src}:

stdenv.mkDerivation rec {
  name = "coreneuron-0.7.0";
  buildInputs = [ stdenv perl cmake cmake-external boost pkgconfig mpiRuntime mod2c];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/coreneuron";
    rev =  "a7231d5aa7725b87c772b690c0f96b0404319414";
    sha256 = "0rlg4dj1rlc546xwlvvqak5nl8vg0217bwh1rm550qx7v3n6svp3";
    leaveDotGit = true;    
  };



#   patchPhase=''
#		mkdir -p coreneuron/mech;
#		cp -r ${mods-src} coreneuron/mech/neurodamus;
#		chmod -R 755 coreneuron/mech/neurodamus;
#	'';
 
  
}



