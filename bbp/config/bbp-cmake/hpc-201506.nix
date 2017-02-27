{stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  name = "bbp-hpc-cmake-2015R2";
  
  
  src = fetchFromGitHub {
  owner = "Eyescale";
  repo = "CMake";
    rev = "5397ec8f6f64480b8885cf563960d9b4b4db86f3";
    sha256 = "1r5nm92r8ign8mh7knark065lgp4dx5d4z0z1ax8q5gjgcyxa6i0";
  };

  
  # enforce -WError for portable build is generally a bad practice
  # this cause any build with clang or recent boost version to fail 
  # due to external warnings
  # suppress it
  installPhase = ''
      sed -i 's@-Werror@@g' Compiler.cmake && 
      mkdir -p $out/share/bbp-cmake/Common &&
      cp -R *  $out/share/bbp-cmake/Common
    '';



} 
