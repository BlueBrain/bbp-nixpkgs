{ stdenv, fetchurl, pkgconfig, boost, hpctools, libxml2, cmake, mpich2, python, zlib, hdf5, doxygen }:

stdenv.mkDerivation rec {
  name = "touchdetector-4.0.0.0.TRUNK";
  buildInputs = [ stdenv pkgconfig boost hpctools zlib cmake mpich2 libxml2 python hdf5 doxygen];

  src = fetchurl {
    url = "https://owncloud.adev.name/public.php?service=files&t=a7822e8d3602a42b397a77a16970c07f&download";
    name = "touchdetector-4.0.0.tar.gz";
    curlOpts = "-k";
    sha256 = "594eff00c5ca32772be62427fbc188191f1663d261f0b03f8dcc3e3de6ad932e";
  };

  enableParallelBuilding = true;
}


