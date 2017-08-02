{ stdenv
, fetchFromGitHub
, which
, zlib
, protobuf
, gtest
, pkgconfig
, c-ares
, openssl
}:


stdenv.mkDerivation rec {
    name = "grpc-${version}";
    version = "1.4.2";
    
    src= fetchFromGitHub {
        owner = "grpc";
        repo = "grpc";
        rev = "5cb6a1f86129fc2833de9a27cfe174260934342b";
        sha256 = "01fvja42b09rxbnkqlcqjdpw9d66hfp094rg57y1wp0m6as5w84s";
    };

    buildInputs = [ zlib gtest protobuf pkgconfig c-ares openssl which ];

    buildPhase = ''
        make prefix=$out
    '';

    installPhase = ''
        make install prefix=$out
    '';
}
