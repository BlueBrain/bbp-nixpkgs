{ stdenv, fetchurl, pkgconfig, boost, hpctools, libxml2, cmake, mpich2, zlib, python, hdf5, doxygen }:

stdenv.mkDerivation rec {
  name = "functionalizer-3.5.0.0.TRUNK";
  buildInputs = [ stdenv pkgconfig boost hpctools zlib cmake mpich2 libxml2 python hdf5 doxygen];

  src = fetchurl {
    url = "https://owncloud.adev.name/public.php?service=files&t=a9c57e41414d2bacef1f246ff00fe14f&download";
    name = "functionalizer-3.5.0.tar.gz";
    curlOpts = "-k";
    sha256 = "a0ae443cbeda3e0b05c994750745655aa7070ee9daeb68cedf039e5cac294f63";
  };
  
  cmakeFlags="-DBoost_USE_STATIC_LIBS=FALSE";  

  enableParallelBuilding = true;
}


