{ stdenv
, fetchFromGitHub
, python
, perl
}:

let
	blis_target = if (stdenv.system == "x86_64-linux") then "intel64"
		      else "generic";

in
stdenv.mkDerivation rec {
  name = "blis-${version}";
  version = "0.2.0";  
  
  src = fetchFromGitHub {
	owner = "flame";
	repo = "blis";
	rev = "f07b176c84dc9ca38fb0d68805c28b69287c938a";
	sha256 = "14zj5jlpdxsp9mlviqlbfkair197i85kvf6m0mjpgfiwh3mrphyw";
  };

  nativeBuildInputs = [ python perl ];

  configureOpt = [      
			"--enable-cblas"
			"--enable-blas"
                        "--enable-shared"
                        "--enable-static" ];

 
  configureFlags = configureOpt ++ 
		   [   
			blis_target
		   ]; 
                      
  enableParallelBuilding = true;  

  passthru = {
    blas = {
      blas_libname = "blis";
      cblas_libname = "blis";
      cblas_header = "cblas.h";
      include_prefix = "blis";
    };

  };  

}


