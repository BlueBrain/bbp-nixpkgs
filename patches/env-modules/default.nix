{
stdenv,
fetchFromGitHub,
tcl,
tcllib
}:


stdenv.mkDerivation rec {
	version = "3.2.10";
	name= "environment-modules-${version}";

	src = fetchFromGitHub {
		owner = "adevress";
		repo ="environment-modules";
		rev = "3.2.10";
		sha256 = "04zi4ad7c9sz9n95m6zgnrjnridvi0a3ncg07p0v9ww76m59lh3a";
	};

	buildInputs = [ stdenv tcl tcllib ];
	
	configureFlags = [ "--with-tcl-lib=${tcl}" 
					   "--with-tcl-inc=${tcl}" ];


	enableParallelBuild = true;


}

