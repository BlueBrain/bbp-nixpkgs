{ stdenv, fetchgitPrivate, cmake, cmake-external, pkgconfig, bison, flex, python }:

stdenv.mkDerivation rec {
  name = "mod2c-1.1.1";
  buildInputs = [ stdenv cmake cmake-external pkgconfig bison flex python];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/mod2c";
    rev = "b3bb86294e1fea3d0768291bec9f062db78bc8db";
    sha256 = "1drkfav5cb8h86ysqrw8yq61msgzlgj7b4mpjy7swclcr0yv69z4";
    leaveDotGit = true;
  };
   
  
}


