{ stdenv
, fetchFromGitHub
, blis
, gfortran
}:


stdenv.mkDerivation rec {
  name = "libflame-${version}";
  version = "5.0-trunk";  
  
  src = fetchFromGitHub {
	owner = "flame";
	repo = "libflame";
	rev = "6e6ccb273c59eee7d61995a8edf821c125134af3";
	sha256 = "1qkhqhnad60p434jvj1mimkbr3xg30sjhprkhdmd1rarnxayhbcs";
  };


  nativeBuildInputs = [ gfortran ];
  buildInputs = [ blis ];

  configureOpt = [   ];

 
  configureFlags = configureOpt ++ 
		   [   
		   ]; 
                      
  enableParallelBuilding = true;  
  
  crossAttrs = {


  };

}


