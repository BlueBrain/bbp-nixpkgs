{
stdenv,
fetchhg,
autoconf,
automake,
libtool,
mpiRuntime,
ncurses,
readline,
flex,
bison,
python,
which,
modlOnly ? false,
nrnOnly ? false,
nrnModl ? null
}:

assert modlOnly -> (nrnOnly == false);
assert nrnOnly -> (modlOnly == false);
assert nrnOnly -> (nrnModl != null);

stdenv.mkDerivation rec {
	name = "neuron-7.4-BBP-${if modlOnly then "modl" else if nrnOnly then "nrn" else "all"}";

	buildInputs = [ automake autoconf libtool mpiRuntime ncurses readline flex bison python which nrnModl];

        src = fetchhg {
		url = "http://www.neuron.yale.edu/hg/neuron/nrn";
		rev = "2a2bd3b1c433";
		sha256 = "1d0g1n8glbrn1bwdxkjhkva6pgrj3v88spmcdjjd85ssik1ij94y"; 
	};


	isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
			then builtins.getAttr "isBlueGene" stdenv else false;



## neuron configure its version number from commit number.
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

	preConfigure = "./build.sh";


	modlOnlyFlags = " --with-nmodl-only --without-x --without-memacs ";

	nrnOnlyFlags = "${if isBGQ then " --enable-bluegeneQ --without-iv --without-memacs --with-paranrn --without-nmodl --host=powerpc64 "
			 else " --with-paranrn --without-iv --without-nmodl " }";


	commonFlags = '' --exec-prefix=''${prefix} '';

	configureFlags =  commonFlags
                         + (if modlOnly then modlOnlyFlags
			  else if nrnOnly then nrnOnlyFlags
			  else '' --with-paranrn --without-iv '');

	makeFlags = " ${if nrnOnly then "NMODL=${nrnModl}/bin/nocmodl" else "" } ";

  	enableParallelBuilding = true;	

	## generate a pkg-config file for viz team cmake compat
	## need to be removed as soon as neurodamus cmake has been refactored
  	preInstall = if nrnOnly then ''
mkdir -p $out/lib/pkgconfig;
cat > $out/lib/pkgconfig/Bluron.pc << EOF
prefix=$out  
exec_prefix= \''${prefix}/
libdir= \''${exec_prefix}/lib
includedir=\''${prefix}/include

Name: Bluron.pc                           
Description: Bluron pkgconfig file 
Version: 2.2.1
Libs: -L\''${libdir}
Cflags: -I\''${includedir}/ 
EOF
''
else
'' '';

    ## remove duplicated libtool / autotools files
    postInstall = if modlOnly then
''
rm -rf $out/share/nrn/libtool
rm -rf $out/*/lib/nrnconf.h
''
else if nrnOnly then
''
ln -s ${nrnModl}/bin/modlunit $out/bin/modlunit
ln -s ${nrnModl}/bin/nocmodl $out/bin/nocmodl
''
else
'' '';   

	propagatedBuildInputs = [ readline which libtool ];
	
}
