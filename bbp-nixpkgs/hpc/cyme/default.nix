{ stdenv, fetchgitExternal, boost, cmake }:

stdenv.mkDerivation rec {
  name = "cyme-0.1";
  buildInputs = [ stdenv boost cmake ];

  src = fetchgitExternal {
    url = "https://github.com/BlueBrain/cyme.git";
    rev = "f8c3708ae10a85706ac487400da75e8e03c0b5b9";
    sha256 = "0q21kp0fnd1nghmx37vc6s8gnssm9ribxdadbs1if2br3wvr1j82";
  }; 

  enableParallelBuilding = true;
  
    
  doCheck = true;
  
  checkTarget = "test";
  
}


