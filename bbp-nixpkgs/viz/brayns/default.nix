{ stdenv
, fetchgitExternal
, cmake
, pkgconfig
, boost
, ospray
, freeglut
, libXmu
, libXi
, glew
, vmmlib 
, lunchbox
, zerobuf
, brion
, hdf5-cpp
, imagemagick
}:


stdenv.mkDerivation rec {
	name = "brayns-${version}";
	version = "0.1.0";

	buildInputs = [ cmake pkgconfig boost ospray freeglut libXmu libXi
					glew vmmlib lunchbox zerobuf brion hdf5-cpp imagemagick ];

	src = fetchgitExternal {
		url  = "https://github.com/BlueBrain/Brayns.git";
		rev = "8e7bad24202163a7073f8c5a4530eb79c82b68c3";
		sha256 = "08nwgmb23imfgp1a2yv5nbc15rihjmjbbcrr3q8y4fjp0pd3420a";
	};


	cmakeFlags = [ 
				"-DOSPRAY_ROOT=${ospray}"
				"-DBRAYNS_REST_ENABLED=OFF" 
				## horrible hack to solve
				## this idiotic -WError at release time....
				"-DXCODE_VERSION=1" ];

  enableParallelBuilding = true;
	

}
