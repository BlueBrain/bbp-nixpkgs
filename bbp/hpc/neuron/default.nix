{
stdenv,
fetchFromGitHub,
autoconf,
automake,
libtool,
mpiRuntime,
ncurses,
readline,
flex,
bison,
python,
pythonVersion ? "2.7",
which,
modlOnly ? false,
nrnOnly ? false,
nrnModl ? null
}:

assert modlOnly -> (nrnOnly == false);
assert nrnOnly -> (modlOnly == false);
assert nrnOnly -> (nrnModl != null);


let 
    neuron-src = {
        versionMajor = "7";
        versionMinor = "5";
        versionDate = "2017-08-06";
        rev = "ee80eb94d3f34e86299a0498b5c1b87f8e8bcaa3";
        sha256 = "0msca5q8yf42scmgfj932vbhzs57yaiy11hydr4vy9zhnzp5kk8r";
    };


    isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
            then builtins.getAttr "isBlueGene" stdenv else false;

    modlOnlyFlags = "--with-nmodl-only --without-x --without-memacs ";

    nrnOnlyFlags =  if isBGQ then 
                        [ 
                            "--enable-bluegeneQ" 
                            "--without-iv" 
                            "--without-memacs" 
                            "--with-paranrn"
                            "--with-multisend"
                            "--without-nmodl"
                            "--host=powerpc64"
                            "--with-nrnpython"
                        ]
                     else [ 
                            "--with-paranrn" 
                            "--with-multisend"
                            "--without-iv" "--without-nmodl" 
                            "--with-nrnpython=${python}/bin/python"
                          ];

    platformPreConfigure = if (isBGQ && nrnOnly) then ''
                                        ## BGQ specific neuron preconfiguration 
                                        export CC=mpixlc_r
                                        export CXX=mpixlcxx_r

                                        export NEURON_PYTHON_VERSION="${pythonVersion}"
                                        export ALL_FLAGS="-qnostaticlink -DLAYOUT=0 -DDISABLE_HOC_EXP -DDISABLE_TIMEOUT -O3 -g -DCORENEURON_BUILD -qlist -qsource -qreport -qsmp=noauto -qthreaded";
                                        export CXXFLAGS="$ALL_FLAGS $CXXFLAGS"
                                        export CFLAGS="$ALL_FLAGS  $CFLAGS";

                                        export PYINCDIR="${python}/include/python${pythonVersion}" 
                                        export PYLIB="-L${python}/lib -lpython${pythonVersion}"
                                        export PYLIBDIR="${python}/lib"
                                        export PYLIBLINK="-L${python}/lib -lpython${pythonVersion}"
                                   ''
                                    else '''';

in 
stdenv.mkDerivation rec {
    name = "neuron-${version}-BBP-${if modlOnly then "modl" else if nrnOnly then "nrn" else "all"}";

    versionMajor = neuron-src.versionMajor;
    versionMinor = neuron-src.versionMinor;
    versionDate = neuron-src.versionDate;

    version = "${versionMajor}.${versionMinor}-dev${versionDate}";

    buildInputs = [ automake autoconf libtool mpiRuntime ncurses readline flex bison python which nrnModl];


	patches = [ ./nrn.patch ];

    src = fetchFromGitHub {
		owner = "nrnhines";
		repo = "nrn";
        rev = neuron-src.rev;
        sha256 = neuron-src.sha256;
    };



## neuron configure its version number from commit number.
## Consequently it fails to build if no VCS have been used
## to checkout the source. This need to be fixed
postPatch = ''
cat  > src/nrnoc/nrnversion.h << EOF
#define NRN_MAJOR_VERSION "${versionMajor}"
#define NRN_MINOR_VERSION "${versionMinor}"
#define GIT_DATE "${versionDate}"
#define GIT_BRANCH "master"
#define GIT_CHANGESET "${neuron-src.rev}"
#define GIT_TREESET "${neuron-src.rev}"
#define GIT_LOCAL "NOT_YET_SUPPORTED"
#define GIT_TAG "NOT_YET_SUPPORTED"
EOF

'';

    ## run the pre-configure neuron script
    ## and force the exec prefix to the absolute install dir
    preConfigure = platformPreConfigure +
                    ''
                    ./build.sh
                    export configureFlags="''${configureFlags} --exec-prefix=''${out}"
                    '';



    configureFlags =   (if modlOnly then modlOnlyFlags
                            else if nrnOnly then nrnOnlyFlags
                            else " --with-paranrn --without-iv ");

    makeFlags = " ${if nrnOnly then "NMODL=${nrnModl}/bin/nocmodl" else "" } ";


    enableParallelBuilding = true;  

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
