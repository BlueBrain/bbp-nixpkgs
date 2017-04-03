{ clangStdenv
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
, config
}:

let 
	# determine instruction set for ispc kernels
	# TODO: skylake 
	embree_instruction_set = "AVX512KNL";
in
clangStdenv.mkDerivation rec {
    name = "embree-${version}";
    version = "2.14.0";

    src = fetchFromGitHub {
        owner = "embree";
        repo = "embree";
        rev = "f8b4b464d6d0380cf45b64ae78d9e1c9d9a9beab";
        sha256 = "1nykv2bliaha00fpis26ar0llda84k9xqbysp53q0a2fav38y1y7";
    };
    

    buildInputs = [ cmake ispc tbb freeglut 
                    mesa libpng libXmu libXi imagemagick ];


#    preConfigure = ''
#	export NIX_CFLAGS_COMPILE="-mavx512f -mavx512pf -mavx512er -mavx512cd $NIX_CFLAGS_COMPILE"
#    '';

    cmakeFlags = [ "-DEMBREE_MAX_ISA=${embree_instruction_set}"];

    buildFlags = [ "VERBOSE=1" ];

    passthru = {
	instruction_set = embree_instruction_set;
    };

}


