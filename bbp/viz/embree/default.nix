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
    version = "2.12.0";

    src = fetchFromGitHub {
        owner = "embree";
        repo = "embree";
        rev = "39d72c4f8ebebbe42c6f5427443c27e7cf6c3529";
        sha256 = "0fklln76pjqiha5av4wzk25vaialqhf1ws58i75vbs8qdyxxnsm8";
    };
    

    buildInputs = [ cmake ispc tbb freeglut 
                    mesa libpng libXmu libXi imagemagick ];



}


