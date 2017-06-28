{ stdenv
, config
, fetchgitPrivate
, which
, mpiRuntime
, autoconf
, automake
, libtool
, pkgconfig
, git
, ncurses
, python
, bison
, flex
, backend ? false
, extraDep ? []
}:

stdenv.mkDerivation rec {
  name = "bluron-2.3.1${if backend==true then "-backend" else ""}";
  buildInputs = [ stdenv git mpiRuntime autoconf automake python libtool pkgconfig 
                which ncurses bison flex] ++ extraDep;


  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/sim/bluron/bbp";
    rev = "795debf91dfc5d33d6f0692357e0b2ff7353450c";
    sha256 = "1vnnq0ppb6amqg99cabmwms5yrl028m66rpixzkq0k9f7hah40jb";
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

  isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
			then builtins.getAttr "isBlueGene" stdenv
			else false; 
  
  backendFlags = ''
               --enable-lm 
	       ${if isBGQ==true then "--enable-bluegeneQ " else ""}
	       --without-iv 
               --without-memacs 
               --with-paranrn --without-nmodl
                '';

  frontendFlags = ''--with-nmodl-only --without-x --without-memacs'';


  defaultFlags =  '' --with-paranrn --without-iv '';
 
  configureFlags = if isBGQ == false 
			then defaultFlags
			else if backend == true then backendFlags
			else frontendFlags;
  
  enableParallelBuilding = true;
}




