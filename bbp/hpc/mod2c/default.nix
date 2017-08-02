{ stdenv, fetchFromGitHub, cmake, pkgconfig, bison, flex, python }:

stdenv.mkDerivation rec {
  name = "mod2c-${version}";
  version = "0.9-201707";

  buildInputs = [ stdenv cmake pkgconfig bison flex python];


  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "mod2c";
    rev = "8604feb1f68d11f93b19e3b7019004f69f460861";
    sha256 = "18cxcx2nf5vc5ivky23gq8yjagqhd7rxqvi477pbd6ai22wir1il";
  };

}


