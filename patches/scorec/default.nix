{ stdenv
, fetchFromGitHub
, cmake
, mpi
, which
}:


stdenv.mkDerivation rec {
    name = "scorec-${version}";
    version = "2.1.0";

    src = fetchFromGitHub {
		owner = "SCOREC";
		repo = "core";
        rev  = "e0103960beeebf7b449788272b0cccca7aa037c3";
        sha256 = "143pbq84lcikab4xk2ga5h99rsdvxscn5y9iri2s6217xw3jxnza";
    };

	preConfigure = ''
			export CC=mpicc
			export CXX=mpic++
	'';

	cmakeFlags = [ 
					"-DSCOREC_CXX_WARNINGS=OFF" "-DSCOREC_CXX_WARNINGS=OFF" 
					"-DIS_TESTING=FALSE"  # "-DENABLE_ZOLTAN=TRUE"
				 ];

    buildInputs = [ mpi ];
    nativeBuildInputs = [ cmake which ];

	buildFlags = [ "VERBOSE=1" ];

    enableParallelBuilding = true;


    crossAttrs = {
        preConfigure = '' '';

        cmakeFlags = [ "-DSCOREC_CXX_WARNINGS=OFF" "-DSCOREC_CXX_WARNINGS=OFF" 
                       "-DCMAKE_C_COMPILER=${mpi.crossDrv}/bin/mpicc" "-DCMAKE_CXX_COMPILER=${mpi.crossDrv}/bin/mpic++" ];


    };

}
