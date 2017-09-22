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
        rev = "2d74e938d6e69d838f5f78b444ab4d32ab8fcaf1";
        sha256 = "0nv9i8a5bs07n33vc6d5sm79wn7c4cf5ygz3mgd6vnlwv32lh4sb";
    };

  src-savestate = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "e8c6bfc02e58e58633a869000a1d1da4c9e3d4d5";
        sha256 = "11hg1aqj6j4j43psz20v7dlvyxrmsy2hp45qdhiw6y00gmyzgm4j";
  };

  src-hippocampus = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "ad0d34c1a5b91bc9bb35fa2a0c2e522921b86aeb";
        sha256 = "13wambrrp2fbwxmm50fl2g2zp80p9i22drjqwm6nmlxskffmmkpb";
  };

  src-simplification = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "6722e912201ad156712a057f0c57d1985234a8f9";
        sha256 = "1z4978698gc98y398lcqxjcqd6n1q793dxrv3yy4yrcmmhzafrf7";
  };


  src-coreneuron = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/neurodamus/bbp";
        rev = "d82001eea54ba1602b6c13c00d871b35b0292fed";
        sha256 = "0fiiqmnh4r4hpy5w3nr8hr49wbgrs9psqi2q9a0m9b1rf81mv1hr";
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



    # TOFIX: no error format security force disable
    # https://bbpteam.epfl.ch/project/issues/browse/BBPBGLIB-365
    neurodamus_cflags="-O2 -g -Wno-error -Wall";

    patches = [ ./neurodamus-printf.patch ];

    buildPhase = ''
        mkdir -p $out

        # copy hocs and modl
        cp -r ./lib/* $out/;

        cd lib

        ${if (isBGQ == true) then ''export CXXFLAGS="-qsmp ''${CXXFLAGS}'' else ''''} 
        ${if (isBGQ == true) then ''export CFLAGS="-qsmp ''${CFLAGS}" '' else ''''}

        # build
        echo "build using nrnivmodl $(which nrnivmodl) ..."
        nrnivmodl -incflags '-I ${reportinglib}/include -I ${hdf5}/include ${neurodamus_cflags} ' -loadflags '-L${reportinglib}/lib -lreportinglib -L${hdf5}/lib -lhdf5' modlib

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


