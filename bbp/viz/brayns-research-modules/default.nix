{ stdenv
, config
, fetchgit
, cmake
, pkgconfig
, ospray
}:

stdenv.mkDerivation rec {
    name = "brayns-research-modules-${version}";
    version = "0.1.0-201806";

    buildInputs = [ cmake ospray ];

    src = fetchgit {
        url = "https://github.com/favreau/Brayns-Research-Modules";
        rev = "eb952bba5df096140468a0a363d2566a1647238e";
        sha256 = "0nzvpzqizc69jkphqlls9xdxin04nhm6g65n31vfi8y54g6x6yax";
    };

	cmakeFlags = [ 
			"-DCOMMON_DISABLE_WERROR=TRUE"
			"-DOSPRAY_ROOT=${ospray}"
		    ];

	# verbose mode for debugging
	makeFlags = [ "VERBOSE=1" ];

    enableParallelBuilding = true;
}
