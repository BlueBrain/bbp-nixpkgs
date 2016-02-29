{ stdenv
, fetchFromGitHub
, pkgconfig
, boost
, cmake
, mpiRuntime
, ncurses
, readline
, doxygen }:

stdenv.mkDerivation rec {
  name = "neuromapp-1.0.0";
  buildInputs = [ stdenv pkgconfig boost cmake mpiRuntime doxygen readline ncurses ];

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "neuromapp";
    rev = "c65d920e206311709ef900aabb6c2690f602a6f8";
    sha256 = "0hgjj39wgdzvn6rsf6wmj46fwynfmjyrm2fzk918svvpc4sa70ya";
  };
    
  cmakeFlags= "-DBoost_NO_BOOST_CMAKE=TRUE -DBoost_USE_STATIC_LIBS=FALSE ";

  enableParallelBuilding = true;
 
  
}


