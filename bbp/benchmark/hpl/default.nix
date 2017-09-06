{
  blas,
  fetchurl,
  mpi,
  stdenv,
  extra_cflags ? [],
}:

stdenv.mkDerivation rec {
  name = "hpl-${version}";
  version = "2.2";

  meta = with stdenv.lib; {
    description = "portable HPC Linpack Benchmark";
    homepage = http://www.netlib.org/benchmark/hpl/;
    platforms = platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}${name}.tar.gz";
    sha256 = "0h7lin7m2rm6mc3sirpn8d0ci6qiziny3r33lxgimqh978b38xdc";
  };

  passthru = {
    src = src;
  };

  buildInputs = [
    blas
    mpi
    stdenv
  ];

  patches = [
    ./makefiles.patch
  ];

  hplarch = "Linux_Intel64";

  preConfigure = ''
    cp setup/Make.${hplarch} .
    env
  '';

  cflags = [
    "-O3"
    "-Wall"
    "-w"
  ] ++ extra_cflags;

  preBuild = ''
      export TOPdir=$PWD
      export CC=mpicc
      export EXTRA_CFLAGS="${builtins.concatStringsSep " " cflags}"
      export LAlib=" "
      export LINKFLAGS_EXTRA="-L${blas}/lib -lblas"
  '';

  makeFlags = [
    "arch=${hplarch}"
  ];
}
