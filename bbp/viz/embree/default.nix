{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, ispc
, tbb
}:


stdenv.mkDerivation rec {
    name = "embree-${version}";
    version = "3.2.3";

    src = fetchFromGitHub {
        owner = "embree";
        repo = "embree";
        rev = "09a6013b79d0a670ca630d121b86265f9b9fab99";
        sha256 = "0920asx0d9v0wcxh7wip98db0vhwz3zkwn2glimy7vfsh9nzinwh";
    };


    buildInputs = [ cmake pkgconfig ispc tbb ];

    cmakeFlags = [
            "-DCMAKE_INSTALL_INCLUDEDIR=include/"
            "-DEMBREE_MAX_ISA=AVX512SKX"
            "-DEMBREE_TUTORIALS=OFF"
            "-DCMAKE_INSTALL_LIBDIR=lib/"
                ];

}

