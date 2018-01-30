{
  cudatoolkit,
  stdenv
}:

stdenv.mkDerivation rec {
  name = "nvidia-benchmarks";

  buildInputs = [
    cudatoolkit
    stdenv
  ];

  src = cudatoolkit + "/samples";

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/bin
    for subdir in `find $src/1_Utilities -mindepth 1 -maxdepth 1 -type d -not -name deviceQueryDrv`; do
      pushd $subdir
      ldd ${cudatoolkit}/nvvm/bin/cicc
      make EXEC="" CUDA_PATH="${cudatoolkit}" EXTRA_NVCCFLAGS=-Wno-deprecated-gpu-targets SMS=""
      popd
    done

    runHook postBuild
  '';
}