{ stdenv
, fetchFromGitHub
, cmake
, boost
}:


stdenv.mkDerivation rec {
    name = "hadoken-${version}";
    version = "0.1-2017.07";
    
    src = fetchFromGitHub {
        owner = "adevress";
        repo = "hadoken";
        rev = "fc25df908679289379502d7f8205f2e7e21b9897";
        sha256 = "10cw86swmcf3micqqlh7cb1lihk2d60jdkc3jm1nybsghny5nvbs";
    };

    buildInputs = [ boost cmake ];

    cmakeFlags = [ "-DHADOKEN_DISABLE_INSTALL=FALSE" ];
}

