{ stdenv
, config
, which
, fetchgitPrivate
, pkgconfig
, hdf5
, mpiRuntime
, pandoc
, zlib
, ncurses
, reportinglib
, nrnEnv
, synapsetool
, coreNeuronMode ? false
, branchName ? "default"
, withSyntool ? false
}:

assert coreNeuronMode -> (branchName == "default");
assert ( branchName != "default" ) -> (coreNeuronMode == false);

let
  isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
            then builtins.getAttr "isBlueGene" stdenv else false;

  src-master = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "a95899fb0115b8f640ff7bd3ac301633138e4df3";
        sha256 = "01ba4rcr712z23ycrmfc637sc476vd9qj3x3r2bfp7ji341nz7gm";
    };

  src-savestate = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "a32826ae6ef264084f99e208fcbf0f7f42c5ce1e";
        sha256 = "1kw3yz85wx94s5r05in13vyz7x04j8ais5rb7f06i88s718an6wg";
  };

  src-hippocampus = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "64e4ea2caab29e7e20b94b43d3ff233192d20eed";
        sha256 = "195sx4g53kzl9yp7qz4pwpnhpxn096rqgxk198h9606clznha30z";
  };

  src-simplification = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "adae0b8e25f8de592e428459efa95b5eb2c893c1";
        sha256 = "1xvpy15wp9p1l5x2vz409rh22mg9zqn5yjm81fki50v981hwmxg5";
  };

  src-mousify = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "eea523b8adae9d7abeff6cc76d10dc9d5fe37dae";
        sha256 = "0y48sdsnj14fd48hyf04xycxsmksgc9k1dj4cj8hvzrdkch3fs61";
  };

  src-bare = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "77bb85b26d7f67935b62c8873e03225c2f12367d";
        sha256 = "05gbpa6snad1gxk8s0ahz0b4xr7i5x4hpjrhxjkxjcxvhiybnprb";
  };

  src-coreneuron = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "980deaf0de430573b15e2358f48cf2dab833c8dc";
        sha256 = "1v85drcd9y16gca0sc0vaj460p4mabq0kkvj1li9l2adypmlj4zs";
  };


in

stdenv.mkDerivation rec {
    name = "neurodamus${if coreNeuronMode then "-coreneuron" else ""}-${version}";
    version = "1.9.0-201803dev";
    meta = {
        description = "Neuron simulators wrapper";
        homepage = "https://bbpcode.epfl.ch/code/#/admin/projects/sim/neurodamus/bbp";
        repository = "ssh://bbpcode.epfl.ch/sim/neurodamus/bbp";
        license = {
          fullName = "Copyright 2018, Blue Brain Project";
        };
        maintainers = with config.maintainers; [
            jamesgkind
            pramodskumbhar
            fouriaux
        ];
    };

    buildInputs = [ stdenv which pkgconfig hdf5 ncurses zlib mpiRuntime reportinglib nrnEnv ]
                    ++ stdenv.lib.optional withSyntool [ synapsetool ];


    src = if (coreNeuronMode) then src-coreneuron
		  else if ( branchName == "savestate" ) then src-savestate
          else if ( branchName == "hippocampus" ) then src-hippocampus
          else if ( branchName == "simplification" ) then src-simplification
          else if ( branchName == "mousify" ) then src-mousify
          else if ( branchName == "bare" ) then src-bare
		  else if ( branchName == "default" ) then src-master
          else throw ( "neurodamus : not a valid branchName name " + branchName ) ;

    patches = if (branchName == "simplification" ) then [ ./gcc-6-security-fix.patch ] else [ ];


    CFLAGS="-O2 -g";
    CXXFLAGS="-O2 -g";

    ModIncFlags="-I ${reportinglib}/include -I ${hdf5}/include " + 
            stdenv.lib.optionalString withSyntool "-I ${synapsetool}/include -DENABLE_SYNTOOL=1";
    ModLoadFlags="-L${reportinglib}/lib -lreportinglib -L${hdf5}/lib -lhdf5 " + 
            stdenv.lib.optionalString withSyntool "-L${synapsetool}/lib -lsyn2";


    buildPhase = ''
        mkdir -p $out

        # copy hocs and modl
        cp -r ./lib/* $out/;

        cd lib

        # add additional flags

        ${if (isBGQ == true) then ''export CXXFLAGS="-qsmp ''${CXXFLAGS}" '' else ''''}
        ${if (isBGQ == true) then ''export CFLAGS="-qsmp ''${CFLAGS}" '' else ''''}

        # build
        echo "build using nrnivmodl $(which nrnivmodl) ..."
        nrnivmodl -incflags '${ModIncFlags}' -loadflags '${ModLoadFlags}' modlib

    '';


    installPhase = ''
        runHook preInstall
        #refactor

        mkdir -p $out/{bin,lib,share}
        mv */special $out/bin/
        mv */.libs/*.so* $out/lib/ || true
        mv */.libs/*.a $out/lib/ || true


    '' + (if (isBGQ == false) then ''
        ## rename accordingly special mech path
        grep -v "\-dll" $out/bin/special > ./special.tmp
        cp ./special.tmp $out/bin/special
        echo " \"\''${NRNIV}\" -dll \"$out/lib/libnrnmech.so\" \"\$@\" " >> $out/bin/special
    '' else ''
    '') +
    (if (branchName == "default") then ''
        mv hoclib/neuronHDF5/convert.sh $out/bin
    '' else ''
    '') +
    ''runHook postInstall
    '';

    passthru = {
        src = src;
    };

    MODLUNIT="${nrnEnv}/share/nrn/lib/nrnunits.lib";

    # we need to patch the last line of special on not-BGQ paltforms
    # current one is not able to work outside of build directory
    # and reference statically this one
    docCss = ../../common/vizDoc/github-pandoc.css;
    postInstall = [ 
	"mkdir -p $doc/share/doc"
    ] ++ (stdenv.lib.optional) (pandoc != null) [ ''
        echo building HTML README
        mkdir -p $out/share/doc/neurodamus/html
        if [ -f ${src}/README.txt ] ; then
            ${pandoc}/bin/pandoc -s -S --self-contained \
              -c ${docCss} ${src}/README.txt \
              -o $out/share/doc/neurodamus/html/index.html
        else
            # Not all branches have a README.txt
            touch $out/share/doc/neurodamus/html/index.html
        fi
    '' ];

  outputs = [ "out" "doc" ];
  propagatedBuildInputs = [ which hdf5 reportinglib ];

}
