{stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  name = "bbp-cmake-2015R2";
  
  
  src = fetchFromGitHub {
  owner = "Eyescale";
  repo = "CMake";
    rev = "03ce689e60ed8d8d1a6eb8c9c541737d194c4847";
    sha256 = "0ybb3x3s41d0zx75i8gip9pdpy73fycn80f6s40l9fy4v3fsj23g";
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
