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
    version = "2.17.4";

    src = fetchFromGitHub {
        owner = "embree";
        repo = "embree";
        rev = "cb61322db3bb7082caed21913ad14869b436fe78";
        sha256 = "0q3r724r58j4b6cbyy657fsb78z7a2c7d5mwdp7552skynsn2mn9";
    };
    

    buildInputs = [ cmake ispc tbb freeglut 
                    mesa libpng libXmu libXi imagemagick ];

    cmakeFlags = [
            "-DCMAKE_INSTALL_INCLUDEDIR=include/"
            "-DCMAKE_INSTALL_LIBDIR=lib/"
		];

}


