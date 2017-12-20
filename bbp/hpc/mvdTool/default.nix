{ boost
, cmake
, config
, cython
, fetchFromGitHub
, hdf5
, highfive
, pandoc
, pkgconfig
, pythonPackages
, stdenv
 }:

let
  # create a python environment with numpy for numpy bindings tests
  python_test_env = with pythonPackages; python.buildEnv.override {
    extraLibs = [ numpy ];
  };
in

stdenv.mkDerivation rec {
  name = "mvd-tool-${version}";
  version = "1.4";
  meta = {
    description = "MVD3 neuroscience file format parser and tool";
    homepage = "https://github.com/BlueBrain/MVDTool";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with config.maintainers; [
      adevress
      ferdonline
      "Arseny V. Povolotsky - arseny.povolotsky@epfl.ch"
    ];
  };
  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "MVDTool";
    rev = "d9261270974f4f25bf278fa19f963600d849ec99";
    sha256 = "1d0dmvznimsg43b4x6fms5wbw5pb3kz0igl51j36nk3pkw998lim";
  };

  buildInputs = [
    boost
    cmake
    hdf5
    highfive
    pkgconfig
    stdenv
  ];
  nativeBuildInputs = [
    cython
    python_test_env
  ];
  propagatedBuildInputs = [ highfive ];

  cmakeFlags= [
    "-DBUILD_PYTHON_BINDINGS=ON"
    "-DCMAKE_INSTALL_LIBDIR=lib/"
  ];
  enableParallelBuilding = true;

  doCheck = false;
  checkPhase = ''
    ctest -V
  '';

  docCss = ../../common/vizDoc/github-pandoc.css;
  postInstall = ''
    mkdir -p $out/share/doc/morpho-mesher/html
    ${pandoc}/bin/pandoc -s -S --self-contained \
      -c ${docCss} ${src}/README.md \
      -o $out/share/doc/morpho-mesher/html/index.html
  '';

  passthru = {
    pythonModule = pythonPackages.python;
  };

}
