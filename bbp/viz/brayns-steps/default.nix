{ stdenv
, config
, fetchgit
, cmake
, pkgconfig
, boost
, vmmlib
, brayns
}:

stdenv.mkDerivation rec {
    name = "brayns-steps-${version}";
    version = "latest";

    buildInputs = [ cmake boost vmmlib brayns ];

    src = fetchgit {
        url = "https://github.com/favreau/Brayns-UC-STEPS.git";
        rev = "729e348c96565a94485d6fc1bf53b329c8506e10";
        sha256 = "14i2148x46sj0xrmrqzirwri3jlrykc4d7a671s6ixrzshjkk5s7";
    };

	cmakeFlags = [ 
			"-DCOMMON_DISABLE_WERROR=TRUE"
		    ];

	# verbose mode for debugging
	makeFlags = [ "VERBOSE=1" ];

    enableParallelBuilding = true;
}
