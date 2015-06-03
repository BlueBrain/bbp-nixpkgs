{ stdenv, fetchgit, cmake, bbp-cmake, boost, pkgconfig, doxygen }:

stdenv.mkDerivation rec {
  name = "servus-1.1.1.0DEV";
  buildInputs = [ stdenv pkgconfig boost cmake bbp-cmake doxygen];

  src = fetchgit {
    url = "https://github.com/HBPVIS/Servus.git";
    
    rev = "74b2cbc07cf488cc20ddcee597084ff8446a6c26";
    sha256 = "0wb7jx394wiadzvm1rdr1bbv699g2n06fcvh0g39fi2mxlrkwzlc";
  };
  
  patchPhase= ''
	ln -s ${bbp-cmake}/share/bbp-cmake/Common CMake/common
  '';
  

  enableParallelBuilding = true;
}




