{ stdenv
, gcc
, config
, fetchgitExternal
, cmake
, which
, mpiRuntime
, autoconf
, automake
, libtool
, pkgconfig
, ncurses
, python
, bison
, flex
}:

stdenv.mkDerivation rec {
  name = "bluron-2.3.1";
  buildInputs = [ stdenv  cmake mpiRuntime autoconf automake python libtool pkgconfig 
                which ncurses bison flex];


  src = fetchgitExternal {
    url = config.bbp_git_ssh + "/sim/bluron/bbp";
    rev = "795debf91dfc5d33d6f0692357e0b2ff7353450c";
    sha256 = "0f3923bb6hnmwhzxkvbazka1zph29kwrz86bm33p00j859x9yriv";
  };
  
  
  ## TODO: Bluron configure its version number from commit number.
  ## Consequently it fails to build if no VCS have been used 
  ## to checkout the source. This need to be fixed
  patchPhase = ''
cat  > src/nrnoc/nrnversion.h << EOF
#define NRN_MAJOR_VERSION "7"
#define NRN_MINOR_VERSION "4"
#define GIT_DATE "2015-07-21"
#define GIT_BRANCH "master"
#define GIT_CHANGESET "NO_GIT"
#define GIT_TREESET "NO_GIT"
#define GIT_LOCAL "NOT_YET_SUPPORTED"
#define GIT_TAG "NOT_YET_SUPPORTED"
EOF
'';
  isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
			then builtins.getAttr "isBlueGene" stdenv
			else false; 
  
 
  enableParallelBuilding = false;
}




