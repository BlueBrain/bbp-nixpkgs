{ stdenv, fetchgitExternal, boost, cmake }:

stdenv.mkDerivation rec {
  name = "cyme-0.1";
  buildInputs = [ stdenv boost cmake ];

  src = fetchgitExternal {
    url = "https://github.com/BlueBrain/cyme.git";
    rev = "f8c3708ae10a85706ac487400da75e8e03c0b5b9";
    sha256 = "18v5dnw951dlqqxm008438zp42f4vb00px0ppik4whmv3mb3g21z";
  }; 

  enableParallelBuilding = true;
  
    
  doCheck = true;
  
  checkTarget = "test";
  
}


