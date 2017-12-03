{ stdenv
, fetchurl
, cmake
, mpi
}:



stdenv.mkDerivation rec {
    name = "parmetis-${version}";
    version = "4.0.3";

    src = fetchurl {
        url = "http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-${version}.tar.gz";
        sha256 = "0pvfpvb36djvqlcc3lq7si0c5xpb2cqndjg8wvzg35ygnwqs5ngj";
    };

    patches = [ ./strip-stupid-path.patch ];

    configurePhase = ''
        make config prefix=$out cc=mpicc cxx=mpic++ 
    '';

    preBuild = ''
        #build sublib metis
        pushd metis
        make config prefix=$out cc=mpicc cxx=mpic++
        make 
        make install
        popd
    '';


    buildInputs = [ mpi ];
    
    nativeBuildInputs = [ cmake ];

}
