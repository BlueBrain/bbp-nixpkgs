{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, ispc
, tbb
}:


stdenv.mkDerivation rec {
    name = "embree-${version}";
    version = "3.5.2";

    src = fetchFromGitHub {
        owner = "embree";
        repo = "embree";
        rev = "e766297adcdaf8e5d8dd996c15aed753255230fd";
        sha256 = "1f3wv57z3li5k04pnhc9m46ljgnvwbc8byss1rpdfzhfgsmzyqv4";
    };


    buildInputs = [ cmake pkgconfig ispc tbb ];

    cmakeFlags = [
            "-DCMAKE_INSTALL_INCLUDEDIR=include/"
            "-DEMBREE_MAX_ISA=AVX512SKX"
            "-DEMBREE_TUTORIALS=OFF"
            "-DCMAKE_INSTALL_LIBDIR=lib/"
                ];

}

