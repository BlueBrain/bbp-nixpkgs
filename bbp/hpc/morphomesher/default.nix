{ boost
, cgal
, cmake
, config
, fetchgitPrivate
, gmp
, morphotool
, mpfr
, pandoc
, pkgconfig
, stdenv
}:

stdenv.mkDerivation rec {
  name = "morpho-mesher-${version}";
  version = "0.1-201708";
  meta = {
    description = "Build meshes from morphologies";
    homepage = "https://github.com/BlueBrain/morpho-mesher";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [
      config.maintainers.adevress
    ];
  };
  src = fetchgitPrivate {
    url = "git@github.com:BlueBrain/morpho-mesher.git";
    rev = "37b5d3ce6f5e6da6674e2250c0b9a4784c16437e";
    sha256 = "1p4fpp03h6l9myaq9c2lpdzcgvxhygrr09fl5w4j1f4q398kccz5";
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

  docCss = ../../common/vizDoc/github-pandoc.css;
  postInstall = ''
    mkdir -p $out/share/doc/reportinglib/html
    ${pandoc}/bin/pandoc -s -S --self-contained \
      -c ${docCss} ${src}/README.md \
      -o $out/share/doc/reportinglib/html/index.html
  '';
  outputs = [ "out" "doc" ];
}
