{
  cudatoolkit,
  mpi,
  stdenv,
  fetchFromGitHub
}:

stdenv.mkDerivation rec {
  name = "shoc-${version}";
  version = "1.1.4-${builtins.substring 0 6 src.rev}";

  meta = with stdenv.lib; {
    description = "Test performance and stability of computing devices";
    longDescription = ''
      The Scalable HeterOgeneous Computing (SHOC) benchmark suite is a
      collection of benchmark programs testing the performance and
      stability of systems using computing devices with non-traditional 
      architectures for general purpose computing. Its initial focus is on
      systems containing Graphics Processing Units (GPUs) and multi-core
      processors, and on the OpenCL programming standard. It can be used on
      clusters as well as individual hosts.
    '';
    homepage = https://github.com/vetter/shoc/;
    license = licenses.bsd3;
    platforms = platforms.unix;
  };

  src = fetchFromGitHub {
    owner = "vetter";
    repo = "shoc";
    rev = "bdcb3f6c1ee3fd25daa3c206b11ff0f6802d9d7f";
    sha256 = "13xim7nxy1y90mmcz7l2ynbinf0fr2qs2byyc2vc208rh29h7zfv";
  };

  passthru = {
    src = src;
  };

  patches = [
    ./find_cuda_libs.patch
  ];

  buildInputs = [
    cudatoolkit
    mpi
    stdenv
  ];

  configureFlags = [
    "--without-opencl"
    ''CUDA_CPPFLAGS="-gencode=arch=compute_35,code=sm_35"''
  ];

  enableParallelBuilding = false;
}
