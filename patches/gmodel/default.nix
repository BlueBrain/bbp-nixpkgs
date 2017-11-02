{
  cmake,
  fetchFromGitHub,
  stdenv
}:

stdenv.mkDerivation rec {
  name = "gmodel-${version}";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "ibaned";
    repo = "gmodel";
    rev = "v${version}";
    sha256 = "02l6s5s23ibb36dbryn21awb8c6kf97dril1nhggypyyahs2hvqs";
  };

  passthru = {
    src = src;
  };

  meta = {
    description = "Gmsh model generation library";
    longDescription = ''
      Gmodel is a C++11 library that implements a minimal CAD kernel based
      on the .geo format used by the Gmsh mesh generation code, and is
      designed to make it easier for users to quickly construct CAD models
      for Gmsh.
    '';
    platforms = stdenv.lib.platforms.all;
    homepage = "https://github.com/ibaned/gmodel";
    license = stdenv.lib.licenses.bsd2;
  };

  buildInputs = [
    cmake
    stdenv
  ];
}
