{ stdenv
, fetchurl
, bzip2
, openssl
, pythonOrigin
, pythonCrossNative ? null
}:



let 
    # here we get an original ( host ) python version with Parser/pgen we need
    python_for_build = pythonOrigin.overrideDerivation ( oldAttr: rec {

	name = oldAttr.name + "-only-pgen";

	installPhase = ''
			mkdir -p $out/share/cross_compile_tools
			cp Parser/pgen $out/share/cross_compile_tools/pgen
		       '';

	postInstall = '' '';
		  

     });


in

(pythonOrigin.overrideDerivation ( oldAttr: rec {
        name =  "python-${version}-bgq";
	version = "2.7.11";

#	src = fetchurl {
#		url = "http://www.python.org/ftp/python/${version}/Python-${version}.tar.xz";
#    		sha256 = "1c8xan2dlsqfq8q82r3mhl72v3knq3qyn71fjq89xikx2smlqg7k";
#	};

        nativeBuildInputs = [ pythonCrossNative ] ++ oldAttr.nativeBuildInputs ;


	patches = [ ./cross-compile.patch ] ++ oldAttr.patches;

	dontStrip = true;

	configureFlags = oldAttr.configureFlags
	 ++  [ 	"--disable-ipv6" 
		"cross_compiling=yes"
		"ac_cv_file__dev_ptc=no"
		"ac_cv_file__dev_ptmx=no"
		"ac_cv_have_long_long_format=yes"
		"BUILD_PGEN=${python_for_build}/share/cross_compile_tools/pgen"
	      ];



})).override {
	stdenv = stdenv;
	bzip2 = bzip2;
	openssl = openssl;

	x11Support = false;
	zlibSupport = false;
	
}

