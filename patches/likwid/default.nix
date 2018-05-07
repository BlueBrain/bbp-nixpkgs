{ stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  name = "likwid-${version}";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "RRZE-HPC";
    repo = "likwid";
    rev = "ef248998af9a6a71e27d59df7f0fc0304123689e";
    sha256 = "1cvas8a33dgrlagvwm1ny7hrl072dzpcgsb8nnb8b3ywkpa610hk";
  };

  preBuild = ''
    makeFlagsArray=(COMPILER=${if stdenv ? isICC then "ICC" else "GCC"} PREFIX=$out INSTALL_CHOWN="");
  '';

  preInstall = ''
    substituteInPlace Makefile --replace "install -m 4755" "install"
  '';
}
