{ stdenv
, fetchgitPrivate
, which
, mpiRuntime
, python
, autoconf
, automake
, libtool
, pkgconfig
, git
, ncurses
, bison
, flex
}:

stdenv.mkDerivation rec {
  name = "bluron-2.2.1";
  buildInputs = [ stdenv git mpiRuntime python autoconf automake libtool pkgconfig 
                which ncurses bison flex];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/bluron/bbp";
    rev = "53f815748c7620065450cdc93c6bcd328ef8e6fb";
    sha256 = "0bxs764saxl9g5r8ha6wmarrm4z6bynr3ia8kgp4ki4vfsifz3d0";
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

  preConfigure = ''sh build.sh'';
  
  preInstall = ''
mkdir -p $out/lib/pkgconfig;
cat > $out/lib/pkgconfig/Bluron.pc << EOF
prefix=$out  
exec_prefix= \''${prefix}
libdir= \''${prefix}/lib
includedir=\''${prefix}/include

Name: Bluron.pc                           
Description: Bluron pkgconfig file 
Version: 2.2.1
Libs: -L\''${libdir}
Cflags: -I\''${includedir}/ 
EOF
'';

  
  configureFlags = ''
                --with-paranrn --without-iv
                --with-nrnpython have_cython=no 
                '';
  
  
  enableParallelBuilding = true;
}




