{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, ispc
, tbb 
, doxygen
, mesa 
, freeglut
, qt4
}:


stdenv.mkDerivation rec {
	name = "ospray-${version}";
	version = "0.1.0";

	buildInputs = [ pkgconfig ispc tbb mesa freeglut qt4 ];

	nativeBuildInputs = [ doxygen cmake ];

	src = fetchFromGitHub {
		owner = "BlueBrain";
		repo  = "OSPRay";
		rev = "e443fd76f2249a55bf7365d0411545693c1856f6";
		sha256 = "02waiw40b8pml27pdxxpg6b510m4vay2c0w6fs44d2dj3yqkh2f2";
	};


	outputs = [ "out" "doc" ];

    propagatedBuildInputs = [ ispc ];

	enableParallelBuilding = true;


}
