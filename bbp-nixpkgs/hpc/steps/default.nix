{ stdenv, fetchgitPrivate, cmake }:

stdenv.mkDerivation rec {
  name = "steps-";
  buildInputs = [ stdenv cmake ];

  src = fetchgitPrivate {
    url = "ssh://git@github.com/CNS-OIST/HBP_STEPS.git";
    rev = "182addb2847d4fc401df0e13f81fdbf32c8f1ac1";
    sha256 = "14ffyqxb9q1hy532ibssw2sxmkqc57j8v71l62bf85gd50yiz48f";
  };

  enableParallelBuilding = true;
 
  
}


