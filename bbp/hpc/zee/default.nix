{
  boost,
  clang-tools,
  cmake,
  fetchgitPrivate,
  libmeshb,
  omega_h,
  openblasCompat,
  petsc,
  pkgconfig,
  stdenv,
  zlib
}:

stdenv.mkDerivation rec {
  name = "zee";
  version = "2018-08";
  src = fetchgitPrivate {
    url = "git@github.com:BlueBrain/zee.git";
    rev = "99177cf3195e6bbf5fb493a616289820ce192928";
    sha256 = "170gabm8c05k3qc6scqpi725vksqxai1s8w9fg0y388i4qzxh4jf";
  };
  meta = {
    description = "subcellular POC with omega_h";
    platforms = stdenv.lib.platforms.all;
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [
      boost
      clang-tools
      cmake
      libmeshb
      omega_h
      omega_h.gmsh
      omega_h.trilinos
      omega_h.trilinos.mpi
      openblasCompat
      petsc
      petsc.hypre
      pkgconfig
      zlib
  ];
  # workaround: bob.cmake does not like when CMAKE_BUILD_TYPE is set
  cmakeBuildType = " ";
  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ctest -V
    runHook postCheck
  '';
}
