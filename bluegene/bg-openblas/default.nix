{ stdenv, fetchurl,  perl, liblapack, config, sharedLibrary ? true
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "0.2.18";

  name = "openblas${if (sharedLibrary == false) then "-static" else ""}-${version}";

  src = fetchurl {
    url = "https://github.com/xianyi/OpenBLAS/tarball/v${version}";
    sha256 = "0vdzivw24s94vrzw4sqyz76mj60vs27vyn3dc14yw8qfq1v2wib5";
    name = "openblas-${version}.tar.gz";
  };

  preBuild = "cp ${liblapack.src} lapack-${liblapack.meta.version}.tgz";

  nativeBuildInputs = [ perl];

  makeFlags =
    [
      # Note that clang is available through the stdenv on OSX and
      # thus is not an explicit dependency.
      ''PREFIX="''$(out)"''
      "USE_OPENMP=0"
      "USE_THREAD=0"
      "INTERFACE64=0"
    ] ++ (stdenv.lib.optional) (sharedLibrary == false) [ "NO_SHARED=1" ];

  crossAttrs =  {

   makeFlags = [ "FC=${config.config}-gfortran" ] ++ makeFlags;

  };


}
