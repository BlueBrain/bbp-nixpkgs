{ stdenv, fetchFromGitHub, cmake, pkgconfig, bison, flex, python }:

stdenv.mkDerivation rec {
  name = "mod2c-${version}";
  version = "0.9-dev201708";

  buildInputs = [ stdenv cmake pkgconfig bison flex python];


  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "mod2c";
    rev = "5b9968b901d53646b3c05e8394e14a8033bd35bd";
    sha256 = "131knhvhixw8pihnp1wpwjcwbj1yys3wadrpj9r5m277pvrkjp0n";
  };

}


