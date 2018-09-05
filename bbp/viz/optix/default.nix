{ stdenv, lib, fetchurl, zlib, unzip }:

with lib;

stdenv.mkDerivation rec {
  name = "optix-${version}";
  version = "5.0.1";

  src = fetchurl {
    url = "file:///gpfs/bbp.cscs.ch/home/podhajsk/bbp-nixpkgs-vis/optix.sh";
    sha256 = "0m9wxwgzjx6sxfariwwvsmj2jny8853hq2xdni6va3sm2pfxq0rg";
  };

  buildInputs = [ unzip ];

  unpackPhase = ''
    chmod +x ${src}
  '';

  installPhase = ''
    mkdir -p $out
    ${src} --skip-license --prefix=$out
  '';

}
