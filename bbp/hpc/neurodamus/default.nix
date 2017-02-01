{ stdenv
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
}:


let 
  isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
            then builtins.getAttr "isBlueGene" stdenv else false;
            
  src-neuron = fetchgitPrivate {
        url = "ssh://bbpcode.epfl.ch/sim/neurodamus/bbp";
        rev = "3bb1ab99a46369be2c9b456b67267ac370e9f0aa";
        sha256 = "1wqwwyp1yfwp0506qvlvmpgzi55xxma6b4f9svfbz9gkmhl65d2b";
    };

  src-coreneuron = fetchgitPrivate {
        url = "ssh://bbpcode.epfl.ch/sim/neurodamus/bbp";
        rev = "fb5c1b5c08a1aba4396624d3db8a46bea68aff4b";
        sha256 = "1m87s31wjyv5kz33pv9s139mbyn3j1bxgj2ivgy1dgcmcc7lr1xq";
  };

in 

stdenv.mkDerivation rec {
    name = "neurodamus${if coreNeuronMode then "-coreneuron" else ""}-${version}";
    version = "1.9.0-201612";

    buildInputs = [ stdenv which pkgconfig hdf5 ncurses zlib mpiRuntime reportinglib nrnEnv ];


    src = if (coreNeuronMode) then src-coreneuron else src-neuron;



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


