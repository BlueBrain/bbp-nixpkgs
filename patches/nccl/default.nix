{
  python,
  pkgconfig,
  fetchFromGitHub,
  cudatoolkit,
  utillinux,
  stdenv
}:

stdenv.mkDerivation rec {
  name = "nccl-${version}";
  version = "1.3.4-1";

  src = fetchFromGitHub {
    owner = "nvidia";
    repo = "nccl";
    rev = "286916a1a37ca1fe8cd43e280f5c42ec29569fc5";
    sha256 = "18niy7syfmyin03lmzrzwxhq1zip8zgv3c80fx98d0iv3cpqf8ss";
  };

  configurePhase = ''
	set -x
	export CUDA_HOME="${cudatoolkit}"
	export CUDA_LIB='${cudatoolkit.lib}/lib'
	mkdir -p $out
	export PREFIX=$out
  '';


  buildInputs = [
    cudatoolkit
  ];

  nativeBuildInputs = [
    python
    pkgconfig
    utillinux
  ];

}
