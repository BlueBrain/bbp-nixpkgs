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

  src-master = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "47db2a75328b236b86ce98c743bf98ae8244a599";
        sha256 = "0pc9pqnd40bzw2bxbm6vsh8xzmd82mnv547h6hs6bn605fkvabri";
    };

  src-savestate = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "e8c6bfc02e58e58633a869000a1d1da4c9e3d4d5";
        sha256 = "0zzqaxzc98zyl00nj24jsd8qawa2airi2nmlh0n5j8gzycvd7z2g";
  };

  src-hippocampus = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "594883e7c676c0aeda955abf815c493428692205";
        sha256 = "15fbcck17hi99svvhvk4af83756sxnzdgpg8kbvk5145sfjfnkr5";
  };

  src-simplification = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "6722e912201ad156712a057f0c57d1985234a8f9";
        sha256 = "13gx9gdjjgqa6i61i2581hzrca8skv2ls81klz7l1sal5kkcf6mw";
  };


  src-coreneuron = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "d82001eea54ba1602b6c13c00d871b35b0292fed";
        sha256 = "0xm750bl9whdam2d8bpvixdp1gagq8c3vaxlf7bs9xyw4jmc814n";
  };


in

stdenv.mkDerivation rec {
    name = "neurodamus${if coreNeuronMode then "-coreneuron" else ""}-${version}";
    version = "1.9.0-201708";

    buildInputs = [ stdenv which pkgconfig hdf5 ncurses zlib mpiRuntime reportinglib nrnEnv ];


    src = if (coreNeuronMode) then src-coreneuron
		  else if ( branchName == "savestate" ) then src-savestate
          else if ( branchName == "hippocampus" ) then src-hippocampus
          else if ( branchName == "simplification" ) then src-simplification
		  else if ( branchName == "default" ) then src-master
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


