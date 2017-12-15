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
    version = "2.17.1";

    src = fetchFromGitHub {
        owner = "embree";
        repo = "embree";
        rev = "90e49f243703877c7714814d6eaa5aa3422a5839";
        sha256 = "1qh6qz79gphgr1ffj7i2qy3sa373bay9xahhsd7ba909s845qh7i";
    };
    

    buildInputs = [ cmake ispc tbb freeglut 
                    mesa libpng libXmu libXi imagemagick ];

    cmakeFlags = [
			"-DCMAKE_INSTALL_INCLUDEDIR=include/"
			"-DCMAKE_INSTALL_LIBDIR=lib/"
		];

}


