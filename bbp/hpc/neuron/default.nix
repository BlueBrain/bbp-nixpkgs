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


let 
    isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
            then builtins.getAttr "isBlueGene" stdenv else false;

    modlOnlyFlags = "--with-nmodl-only --without-x --without-memacs ";

    nrnOnlyFlags =  if isBGQ then 
                        [ 
                            "--enable-bluegeneQ" 
                            "--without-iv" 
                            "--without-memacs" 
                            "--with-paranrn"
                            "--without-nmodl"
                            "--host=powerpc64"
                        ]
                     else [ 
                            "--with-paranrn" 
                            "--without-iv" "--without-nmodl" 
                            "--with-nrnpython=${python}/bin/python"
                          ];

in 
stdenv.mkDerivation rec {
    name = "neuron-${version}-BBP-${if modlOnly then "modl" else if nrnOnly then "nrn" else "all"}";

    versionMajor = "7";
    versionMinor = "5";
    versionDate= "201610";

    version = "${versionMajor}.${versionMinor}-${versionDate}";

    buildInputs = [ automake autoconf libtool mpiRuntime ncurses readline flex bison python which nrnModl];


	patches = [ ./nrn.patch ];

    src = fetchhg {
        url = "http://www.neuron.yale.edu/hg/neuron/nrn";
        rev = "60a58922f20e";
        sha256 = "1s7fx97znc4h9qx1x5jhg2i4bp478afkfhi6h36na219g8xkw2jx"; 
    };



## neuron configure its version number from commit number.
## Consequently it fails to build if no VCS have been used
## to checkout the source. This need to be fixed
patchPhase = ''
cat  > src/nrnoc/nrnversion.h << EOF
#define NRN_MAJOR_VERSION "${versionMajor}"
#define NRN_MINOR_VERSION "${versionMinor}"
#define GIT_DATE "${versionDate}"
#define GIT_BRANCH "master"
#define GIT_CHANGESET "NO_GIT"
#define GIT_TREESET "NO_GIT"
#define GIT_LOCAL "NOT_YET_SUPPORTED"
#define GIT_TAG "NOT_YET_SUPPORTED"
EOF

'';

    ## run the pre-configure neuron script
    ## and force the exec prefix to the absolute install dir
    preConfigure = ''
                    ./build.sh
                    export configureFlags="''${configureFlags} --exec-prefix=''${out}"
                    '';



    configureFlags =   (if modlOnly then modlOnlyFlags
                            else if nrnOnly then nrnOnlyFlags
                            else " --with-paranrn --without-iv ");

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

## standardise python neuron install dir if any
if [[ -d $out/lib/python ]]; then
    LOCAL_PYTHONVER="$(python -c "from distutils.sysconfig import get_python_version; print(get_python_version())")"
    LOCAL_PYTHONDIR="$out/lib/python''${LOCAL_PYTHONVER}"
    mkdir -p ''${LOCAL_PYTHONDIR}
    mv ''${out}/lib/python ''${LOCAL_PYTHONDIR}/site-packages
fi
''
else
'' 
'';   

    propagatedBuildInputs = [ readline which libtool ];
    
}
