{stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  name = "bbp-cmake-2015.1.0.0DEV";
  
  
  src = fetchFromGitHub {
	owner = "Eyescale";
	repo = "CMake";
    rev = "0bd6baa5ef821409564ec2d16e268d68c6ef44a0";
    sha256 = "18vicw6f6ygzbixii26svv9jc286xmjhn78v10zl6zrcr49vxf06";
  };

  installPhase = ''
      mkdir -p $out/share/bbp-cmake/Common
      cp -R *  $out/share/bbp-cmake/Common
    '';



} 
