{ stdenv, fetchgitPrivate, cmake, cmake-external, pkgconfig, bison, flex, python }:

stdenv.mkDerivation rec {
  name = "mod2c-1.1.1";
  buildInputs = [ stdenv cmake cmake-external pkgconfig bison flex python];


  src = fetchgitPrivate {
    url = "ssh://bbpcode.epfl.ch/sim/mod2c";
    rev = "b3bb86294e1fea3d0768291bec9f062db78bc8db";
    sha256 = "1rihcss143fsjv9l7bmxk8swk8w711dykamlab8kg5hzww5rmy06";
    leaveDotGit = true;
  };
   
  
}


