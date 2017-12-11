{ stdenv
, fetchFromGitHub
, cmake
, ispc
, tbb
, freeglut 
, mesa
, libpng 
, libXmu
, libXi
, imagemagick
}:


stdenv.mkDerivation rec {
    name = "embree-${version}";
    version = "2.17.0";

    src = fetchFromGitHub {
        owner = "embree";
        repo = "embree";
        rev = "c48d21814cd5c590c7d77e1ac699c586be7ada70";
        sha256 = "0ri4xndxwc18622kzcz4q0s5ff1dcc6d5vfzimcmxilzm369c2p8";
    };
    

    buildInputs = [ cmake ispc tbb freeglut 
                    mesa libpng libXmu libXi imagemagick ];

    cmakeFlags = [
			"-DCMAKE_INSTALL_INCLUDEDIR=include/"
			"-DCMAKE_INSTALL_LIBDIR=lib/"
		];

}


