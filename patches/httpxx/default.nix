{ stdenv
, fetchgit
, cmake
, doxygen
}:


stdenv.mkDerivation rec {
	name = "httpxx-${version}";
	version = "0.1-2016.09";

	src = fetchgit {
		url  = "https://github.com/AndreLouisCaron/httpxx.git";
		rev = "c24d7f16f9f3a2675f1915460908a16ee55b66e0";
		sha256 = "1q89nxji54n110fnd717bvhfywsncnjp65kam9xa3fqv82r2p3mr";
	};

	buildInputs = [ cmake doxygen ];

	preConfigure = ''
			sed -i  's/STATIC/SHARED/g' httpxx/CMakeLists.txt
	'';



    enableParallelBuilding = true;


}
