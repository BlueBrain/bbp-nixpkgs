{
stdenv,
neuron-src,
autoconf,
automake,
libtool,
mpiRuntime,
ncurses,
readline,
flex,
bison,
python,
interview,
which,
multiSend ? true,
...
}:

let 
    name_extension = ''BBP${if (multiSend == false) then ''-nomultisend'' else ''''}'';
in

stdenv.mkDerivation rec {
    name = "neuron-${version}-${name_extension}";

    versionMajor = neuron-src.info.versionMajor;
    versionMinor = neuron-src.info.versionMinor;
    versionDate = neuron-src.info.versionDate;

    version = "${versionMajor}.${versionMinor}-dev${versionDate}";

    buildInputs = [ automake autoconf libtool mpiRuntime ncurses readline flex bison python which interview];

    src = neuron-src.srcs;

    ## neuron configure its version number from commit number.
    ## Consequently it fails to build if no VCS have been used
    ## We give him a commit version manually defined

    ## run the pre-configure neuron script
    ## and force the exec prefix to the absolute install dir
    preConfigure = ''
        ./build.sh
        cat  > src/nrnoc/nrnversion.h << EOF
        #define GIT_BRANCH "master"
        #define GIT_CHANGESET "${neuron-src.info.rev}"
        #define GIT_DESCRIBE "NOT_YET_SUPPORTED"
        #define GIT_DATE "${versionDate}"
        #define GIT_LOCAL "NOT_YET_SUPPORTED"
        #define GIT_TAG "NOT_YET_SUPPORTED"
        #define GIT_TREESET "${neuron-src.info.rev}"
        #define NRN_MAJOR_VERSION "${versionMajor}"
        #define NRN_MINOR_VERSION "${versionMinor}"
        EOF
        export configureFlags="''${configureFlags} --exec-prefix=''${out}"
    '';

    configureFlags = [
        "--with-paranrn"
        ''${if (interview != null) then ''--with-iv=${interview}'' else ''--without-iv''}''
    ] 
    ++ (stdenv.lib.optional) (multiSend) [ "--with-multisend" ]
    ++ (stdenv.lib.optional) (python != null) [ "--with-nrnpython=${python}/bin/python" ];

    enableParallelBuilding = true;  

    postInstall = '' 
    ## standardise python neuron install dir if any
    if [[ -d $out/lib/python ]]; then
        LOCAL_PYTHONVER="$(python -c "from distutils.sysconfig import get_python_version; print(get_python_version())")"
        LOCAL_PYTHONDIR="$out/lib/python''${LOCAL_PYTHONVER}"
        mkdir -p ''${LOCAL_PYTHONDIR}
        mv ''${out}/lib/python ''${LOCAL_PYTHONDIR}/site-packages
    fi'';

    propagatedBuildInputs = [ readline which libtool interview ];

    passthru = {
        iv = interview;
    };
}
