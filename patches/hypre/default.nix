{
  cmake,
  fetchFromGitHub,
  mpi,
  stdenv,
  with64bits ? true
}:

stdenv.mkDerivation rec {
  name = "hypre-${version}${if (with64bits) then "-64b" else "-32b"}";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "LLNL/";
    repo = "hypre";
    rev = "v${version}";
    sha256 = "12iciad718rf7vcl33klza7dcnxxa5581yav7c72l81m7mswihq9";
  };

  passthru = {
    src = src;
  };

  meta = {
    description = "Parallel solvers for sparse linear systems featuring multigrid methods";
    platforms = stdenv.lib.platforms.all;
    homepage = "https://github.com/LLNL/hypre";
    license = stdenv.lib.licenses.gpl2;
  };

  buildInputs = [
    cmake
    mpi
  ];

  postUnpack = "sourceRoot+=/src";

  preConfigure = ''
    cmakeFlagsArray=(
      "-DCMAKE_C_COMPILER=mpicc"
      "-DCMAKE_CXX_COMPILER=mpic++"
      "-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
      "-DHYPRE_BIGINT:BOOL=${if with64bits then "ON" else "OFF"}"
      "-DHYPRE_INSTALL_PREFIX=$out"
    )
  '';

  doCheck = false;
}
