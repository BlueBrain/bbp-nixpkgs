{ stdenv
, config
, boost
, cgal
, cmake
, fetchgitPrivate
, gmp
, morphotool
, mpfr
, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "morpho-mesher-${version}";
  version = "0.1-201708";

  meta = {
    description = "Build meshes from morphologies";
    homepage = "https://github.com/BlueBrain/morpho-mesher";
    license = stdenv.lib.licenses.gpl2;
  };

  src = fetchgitPrivate {
    url = "git@github.com:BlueBrain/morpho-mesher.git";
    rev = "89dc7db96d4bb43f5513daee5366a2e5ea34b990";
    sha256 = "0fcn01yswzdli60kb59nd930bykm5mvwi4n1xajryrx02m7p543w";
  };

  passthru = {
    src = src;
  };

  buildInputs = [
    boost
    cgal
    cmake
    gmp
    morphotool
    mpfr
    pkgconfig
    stdenv
  ];

  cmakeFlags = [
    "-DUNIT_TESTS=OFF"
    "-DHADOKEN_UNIT_TESTS:BOOL=OFF"
  ];

  enableParallelBuilding = false;

  doCheck = true;

  checkPhase = ''
    ctest -V
  '';
}
