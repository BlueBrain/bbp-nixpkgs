{ stdenv, fetchurl, boost, libxml2, cmake, mpich2, pkgconfig, python, hdf5, doxygen }:

stdenv.mkDerivation rec {
  name = "hpctools-3.2.0.0DEV";
  buildInputs = [ stdenv pkgconfig boost cmake mpich2 libxml2 python hdf5 doxygen];

  src = fetchurl {
    url = "https://owncloud.adev.name/public.php?service=files&t=2fced759f5bb316d91612eee5cdb6f99&download";
    name = "hpctools-3.2.0.tar.gz";
    curlOpts = "-k";
    sha256 = "7512fc778e12a807ee5c69324b96b4b1a72243c98d7024c3ac2b9e51303433d6";
  };

  enableParallelBuilding = true;
}

