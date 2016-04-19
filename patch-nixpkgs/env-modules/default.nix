{
stdenv,
fetchurl,
tcl,
tcllib
}:


stdenv.mkDerivation rec {
	version = "3.2.10";
	name= "environment-modules-${version}";

	src = fetchurl {
		url = "https://sourceforge.net/projects/modules/files/Modules/modules-${version}/modules-${version}.tar.gz/download";
		sha256 = "fb05c82a83477805a1d97737a9f0ca0db23f69b7bce504f1609ba99477b03955";
		name = "${name}.tar.gz";
	};

	buildInputs = [ stdenv tcl tcllib ];
	
	configureFlags = [ "--with-tcl-lib=${tcl}" 
					   "--with-tcl-inc=${tcl}" ];


	enableParallelBuild = true;


}

