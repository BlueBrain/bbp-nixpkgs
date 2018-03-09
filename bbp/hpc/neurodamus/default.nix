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
, coreNeuronMode ? false
, branchName ? "default"
}:

assert coreNeuronMode -> (branchName == "default");
assert ( branchName != "default" ) -> (coreNeuronMode == false);

let
  isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
            then builtins.getAttr "isBlueGene" stdenv else false;

  src-master = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "43ff6eb82af7cf0a3c63359d1dbf1f44cb8b49ef";
        sha256 = "010lrl4ls2lgrqrz0n1z0j6kvrhb3fmzabf6k881cbxljs7pwy1c";
    };

  src-savestate = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "e8c6bfc02e58e58633a869000a1d1da4c9e3d4d5";
        sha256 = "11hg1aqj6j4j43psz20v7dlvyxrmsy2hp45qdhiw6y00gmyzgm4j";
  };

  src-hippocampus = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "b9f232a40752c61c26a014f446ea530b628d1e36";
        sha256 = "1zl2xs3czry3idgj9h8cdwv0pxc8x1vrpzdik7ka0n053w05n0s1";
  };

  src-simplification = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "6ef13a2b5137aa892b0134118fe019a137d08e5f";
        sha256 = "1ihj87xlw2g9q60srfr8y4ml5k076n4xhm855z94vkxqzq4hr9fj";
  };

  src-mousify = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "d8e2ddf786cdbb7faa3e93e0f198659946b0b0c5";
        sha256 = "0j61pk2gpj6vhqxydyxhcyw358cyszipnm2a0c4xwgllsqcy430g";
  };


  src-coreneuron = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "980deaf0de430573b15e2358f48cf2dab833c8dc";
        sha256 = "1v85drcd9y16gca0sc0vaj460p4mabq0kkvj1li9l2adypmlj4zs";
  };


in

stdenv.mkDerivation rec {
    name = "neurodamus${if coreNeuronMode then "-coreneuron" else ""}-${version}";
    version = "1.9.0-201803";
    meta = {
        description = "Neuron simulators wrapper";
        homepage = "https://bbpcode.epfl.ch/code/#/admin/projects/sim/neurodamus/bbp";
        license = {
          fullName = "Copyright 2018, Blue Brain Project";
        };
        maintainers = with config.maintainers; [
            jamesgkind
            pramodskumbhar
            fouriaux
        ];
    };

    buildInputs = [ stdenv which pkgconfig hdf5 ncurses zlib mpiRuntime reportinglib nrnEnv ];


    src = if (coreNeuronMode) then src-coreneuron
		  else if ( branchName == "savestate" ) then src-savestate
          else if ( branchName == "hippocampus" ) then src-hippocampus
          else if ( branchName == "simplification" ) then src-simplification
          else if ( branchName == "mousify" ) then src-mousify
		  else if ( branchName == "default" ) then src-master
          else throw ( "neurodamus : not a valid branchName name " + branchName ) ;

    patches = if (branchName == "simplification" || branchName == "savestate") then [ ./gcc-6-security-fix.patch ] else [ ];


    CFLAGS="-O2 -g";
    CXXFLAGS="-O2 -g";

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
        nrnivmodl -incflags '-I ${reportinglib}/include -I ${hdf5}/include' -loadflags '-L${reportinglib}/lib -lreportinglib -L${hdf5}/lib -lhdf5' modlib

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
    postInstall = ''
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
    '';

  outputs = [ "out" "doc" ];
  propagatedBuildInputs = [ which hdf5 reportinglib ];

}
