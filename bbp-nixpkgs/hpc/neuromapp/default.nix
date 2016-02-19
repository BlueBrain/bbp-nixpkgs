{ stdenv, fetchFromGitHub, pkgconfig, boost, cmake, mpiRuntime, doxygen }:

stdenv.mkDerivation rec {
  name = "neuromapp-1.0.0";
  buildInputs = [ stdenv pkgconfig boost cmake mpiRuntime doxygen];

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "neuromapp";
    rev = "4ed218a746cd0e4c5d1c193fac30942707b3b521";
    sha256 = "1rmndp5gjx4cm51sklw3zd5nrjyd84y5kq45x808r985accyj1nw";
  };
    
  cmakeFlags= "-DBoost_NO_BOOST_CMAKE=TRUE -DBoost_USE_STATIC_LIBS=FALSE ";

  enableParallelBuilding = true;
 
  
}


