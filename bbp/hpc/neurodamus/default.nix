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
        rev = "b85d0085c978d54e3de0a88bb460e8e187f0847d";
        sha256 = "03g683v243dzj6q9hcxc7m04l07v499xw12pn3jb4wg1l3fy8frr";
    };

  src-coreneuron = fetchgitPrivate {
        url = "ssh://bbpcode.epfl.ch/sim/neurodamus/bbp";
        rev = "93e3a8683527ef4dd986d2779dc98c2d44106bb7";
        sha256 = "10g0rm3l0qbgk7ylqsa38bpylnz4329ckr7yx2rax586ay7zp51g";
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
        
        
        ## rename accordingly special mech path
        grep -v "\-dll" $out/bin/special > ./special.tmp
        cp ./special.tmp $out/bin/special
        echo " \"\''${NRNIV}\" -dll \"$out/lib/libnrnmech.so\" \"\$@\" " >> $out/bin/special
        
        
        
    '';


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


