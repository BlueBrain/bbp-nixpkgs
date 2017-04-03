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
, saveStateBranch ? false
}:

assert coreNeuronMode -> (saveStateBranch == false);
assert saveStateBranch -> (coreNeuronMode == false);

let 
  isBGQ = if builtins.hasAttr "isBlueGene" stdenv == true
            then builtins.getAttr "isBlueGene" stdenv else false;
            
  src-neuron = fetchgitPrivate {
        url = "ssh://bbpcode.epfl.ch/sim/neurodamus/bbp";
        rev = "8b111ecbaa81fc2395c503062d5c509d2f0b78b4";
        sha256 = "17b1n4k1bbd1h23qmxg5livqxjxa089i976d57xk67aqdr5wx73z";
    };

  src-neuron-savestate = fetchgitPrivate {
        url = "ssh://bbpcode.epfl.ch/sim/neurodamus/bbp";
        rev = "f428f461e3a875f5d4110c470a4df95e4c8636a2";
        sha256 = "27b1n4k1bbd1h23qmxg5livqxjxa089i976d57xk67aqdr5wx73z";
  };

  src-coreneuron = fetchgitPrivate {
        url = "ssh://bbpcode.epfl.ch/sim/neurodamus/bbp";
        rev = "d81f169f32aab8ba57fd87ea82597fbb614b9c16";
        sha256 = "0fvwd9kpkfp05w6kvsnj98p4c3hgv8w0ycn9wf4gn211yxb72nsb";
  };


in 

stdenv.mkDerivation rec {
    name = "neurodamus${if coreNeuronMode then "-coreneuron" else ""}-${version}";
    version = "1.9.0-201703";

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


