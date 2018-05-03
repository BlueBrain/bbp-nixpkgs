{
  blas,
  buildinfo,
  fetchurl,
  mpi,
  stdenv,
  extra_cflags ? [],
}:

stdenv.mkDerivation rec {
  name = "hpl-${version}";
  version = "2.2";

  bi = buildinfo {
    metas = {
      inherit version;
    };
  };

  meta = with stdenv.lib; {
    description = "portable HPC Linpack Benchmark";
    longDescription = ''
      HPL is a software package that solves a (random) dense linear system
      in double precision (64 bits) arithmetic on distributed-memory
      computers. It can thus be regarded as a portable as well as freely
      available implementation of the High Performance Computing Linpack
      Benchmark.
    '';
    homepage = http://www.netlib.org/benchmark/hpl/;
    platforms = platforms.unix;
    license = licenses.ipl10;
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
  ] ++ stdenv.lib.optionals ( stdenv ? isICC )  [ 
    "-mcmodel medium"
    "-shared-intel"
    "-qopenmp"
    "-qopt-streaming-stores always"
  ] ++ extra_cflags;


  ldflags = if blas ? isMKL then "-lmkl_rt" else "-lblas";

  preBuild = ''
      export TOPdir=$PWD
      export CC=mpicc
      export EXTRA_CFLAGS="${builtins.concatStringsSep " " cflags}"
      export LAlib=" "
      export LINKFLAGS_EXTRA="-L${blas}/lib ${ldflags}"
  '';

  makeFlags = [
    "arch=${hplarch}"
    "OMP_DEFS="
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/${hplarch}/xhpl $out/bin
  '';

  postInstall = ''
    ${bi.annotate} $out
  '';
}
