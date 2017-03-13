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
    version = "2.14.0";

    src = fetchFromGitHub {
        owner = "embree";
        repo = "embree";
        rev = "c24bc5500e40f43195e443d6499c465af4994bdf";
        sha256 = "0n8alajfz86n80ybgdhd016m56ib0m8ncjbrgjc8lanx16xdyl2v";
    };
    

    buildInputs = [ cmake ispc tbb freeglut 
                    mesa libpng libXmu libXi imagemagick ];



}


