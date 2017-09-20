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
    version = "2.16.5";

    src = fetchFromGitHub {
        owner = "embree";
        repo = "embree";
        rev = "68219475088e35bf5a0f603ae777743b680bc3b2";
        sha256 = "1h8my7r35q6x203nbwjf0dspj5y3njlgx4nggfiswrgwvx1741sr";
    };
    

    buildInputs = [ cmake ispc tbb freeglut 
                    mesa libpng libXmu libXi imagemagick ];



}


