{ stdenv, fetchFromGitHub, ghc }:

stdenv.mkDerivation rec {
  name = "rdmini-0.1";
  buildInputs = [ stdenv ghc ];

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "rdmini";
    rev = "8810e1d165b1fde24d8e507a84e7f3b13335c17d";
    sha256 = "15n5nx44r56g51k984lsjf8cm3zlqwqi223vbwxvkbzzfnrxv5sk";
  }; 

  configurePhase = ''
			cd build;
		   '';

  enableParallelBuilding = true;

 # bug in doc generation for now, copy source
  installPhase = ''
		   mkdir -p $out/share/doc/rdmini;
		   cp -r ../doc/* $out/share/doc/rdmini;
		 ''; 

    
  doCheck = true;
  
  checkTarget = "test";
  
}


