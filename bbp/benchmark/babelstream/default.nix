{
  cudatoolkit,
  fetchFromGitHub,
  stdenv
}:

stdenv.mkDerivation rec {
  name = "babelstream";
  version = "3.3";

  meta = with stdenv.lib; {
    description = "STREAM, for lots of devices written in many programming models";
    longDescription = ''
    Measure memory transfer rates to/from global device memory on GPUs.
    This benchmark is similar in spirit, and based on, the STREAM benchmark
    for CPUs.

    Unlike other GPU memory bandwidth benchmarks this does not include the 
    PCIe transfer time.
    '';
    homepage = http://uob-hpc.github.io/BabelStream;
    platforms = platforms.unix;
  };

  src = fetchFromGitHub {
    owner = "UoB-HPC";
    repo = "BabelStream";
    rev = "87eb4361b49d73f9b6da58b6676a781e4a243220";
    sha256 = "0bwqn048r8n19qwgvp9wzwjnddp198a9yjiwj05ar9vwdd3nfj1k";
  };

  buildInputs = [
    cudatoolkit
    stdenv
  ];

  makeFlags = "-f CUDA.make";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install cuda-stream $out/bin/
    runHook postInstall
  '';
}
