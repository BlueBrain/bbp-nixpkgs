{ stdenv
, config
, which
, fetchgitPrivate
, pkgconfig
, hdf5
, mpiRuntime
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

  src-neuron = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "11eebb3ac9415d67d286c24ee9f5b5c66b432c86";
        sha256 = "031wrf6zj1zl6sy79bcciijjcinhqgah4nj53xxg49k7l1sa8bd1";
    };

  src-neuron-savestate = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "c074699559fdf3bb9b186e50e07e4ba4682b3fb8";
        sha256 = "1b0cmyh4ls7q50z6rn6nrx66p0h22fp82di2wr3xkxz9n3hh60n5";
  };

  src-neuron-hippocampus = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "0f0f044d8704d47a09440e172fe115845d6c6206";
        sha256 = "0xp3025wkarnns8kxy4vph48mndmijpqlqbd4p6bfmaa3j9sx7cb";
  };



  src-coreneuron = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "d81f169f32aab8ba57fd87ea82597fbb614b9c16";
        sha256 = "0fvwd9kpkfp05w6kvsnj98p4c3hgv8w0ycn9wf4gn211yxb72nsb";
  };


in

stdenv.mkDerivation rec {
    name = "neurodamus${if coreNeuronMode then "-coreneuron" else ""}-${version}";
    version = "1.9.0-201706";

    buildInputs = [ stdenv which pkgconfig hdf5 ncurses zlib mpiRuntime reportinglib nrnEnv ];


    src = if (coreNeuronMode) then src-coreneuron
		  else if ( branchName == "savestate" ) then src-neuron-savestate
          else if ( branchName == "hippocampus" ) then src-neuron-hippocampus
		  else if ( branchName == "default" ) then src-neuron
          else throw ( "neurodamus : not a valid branchName name " + branchName ) ;



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
    '' else '' '');





    passthru = {
        src = src;
    };

    MODLUNIT="${nrnEnv}/share/nrn/lib/nrnunits.lib";

    # we need to patch the last line of special on not-BGQ paltforms
    # current one is not able to work outside of build directory
    # and reference statically this one
    postInstall = if isBGQ == false then
    ''
    ## rename accordingly special mech path
    grep -v "\-dll" $out/bin/special > ./special.tmp
    cp ./special.tmp $out/bin/special
    echo " \"\''${NRNIV}\" -dll \"$out/lib/libnrnmech.so\" \"\$@\" " >> $out/bin/special
    ## nrn mech is not installed properly by cmake
    mkdir -p $out/lib
    cp lib/*/*/.libs/*.so* $out/lib/
    ''
    else
    '' '';

    propagatedBuildInputs = [ which hdf5 reportinglib ];

}


