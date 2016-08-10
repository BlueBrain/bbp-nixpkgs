{ stdenv
, fetchFromGitHub
}:


stdenv.mkDerivation rec {
  name = "blis-${version}";
  version = "0.2.0";  
  
  src = fetchFromGitHub {
	owner = "flame";
	repo = "blis";
	rev = "898614a555ea0aa7de4ca07bb3cb8f5708b6a002";
	sha256 = "05dzcy32ddq4j4hzh3jarzr2ya0sd8qv6v26rxraxbl9yji9g7cn";
  };

  patches = [

		./enable-cblas-compat.patch

	    ];

  configureOpt = [      "--enable-debug=opt"
                        "--enable-shared"
                        "--enable-static" ];

 
  configureFlags = configureOpt ++ 
		   [   
			"auto" 
		   ]; 
                      
  enableParallelBuilding = true;  
  
  crossAttrs = {
	###
	## dont add --host and --build... not standard configure file
	##
	dontSetConfigureCross = true;

	configureFlags = configureOpt ++ 
		   (
		   	if ( (stdenv.lib.attrByPath [ "cross" "config" ] "none" stdenv) == "powerpc64-bgq-linux" ) then [  "auto" ] ## generic impl for now 
		   	else [ "auto" ] 
	           );


  };

}


