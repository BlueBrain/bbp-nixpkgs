{stdenv, fetchgit}:

stdenv.mkDerivation rec {
  name = "bbp-cmake-2015.1.0.0DEV";
  
  
  src = fetchgit {
    url = "https://github.com/Eyescale/CMake.git";
    rev = "0bd6baa5ef821409564ec2d16e268d68c6ef44a0";
    sha256 = "0k12k1x9vr9389jg52gwnv23skncxsgp19gq6adikw2v5y6hhxnr";
  };

  installPhase = ''
      mkdir -p $out/share/bbp-cmake/Common
      cp -R *  $out/share/bbp-cmake/Common
    '';



} 
