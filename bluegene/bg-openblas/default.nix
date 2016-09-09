{ stdenv, fetchurl,  perl, liblapack, config
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "0.2.18";

  name = "openblas-${version}";
  src = fetchurl {
    url = "https://github.com/xianyi/OpenBLAS/tarball/v${version}";
    sha256 = "0vdzivw24s94vrzw4sqyz76mj60vs27vyn3dc14yw8qfq1v2wib5";
    name = "openblas-${version}.tar.gz";
  };

  preBuild = "cp ${liblapack.src} lapack-${liblapack.meta.version}.tgz";

  nativeBuildInputs = [ perl];

  makeFlags =
    [
      "FC=gfortran"
      # Note that clang is available through the stdenv on OSX and
      # thus is not an explicit dependency.
      "CC=${if stdenv.isDarwin then "clang" else "gcc"}"
      ''PREFIX="''$(out)"''
      "USE_OPENMP=${if stdenv.isDarwin then "0" else "1"}"
    ];

  crossAttrs = rec {

   makeFlags = [ "FC=${config.config}-gfortran" ''PREFIX="''$(out)"'' "USE_OPENMP=1" "TARGET=POWER7" ];

  };


}
