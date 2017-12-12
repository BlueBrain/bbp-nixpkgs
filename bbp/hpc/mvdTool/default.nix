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
    rev = "c96ecaaa4daf280fc2a82b64d9d64bb025c5366f";
    sha256 = "1hf57qy4gz9iq3qni12rxzr8lhyzdnjqdcsiavfrx1b6vdvw1jp8";
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
    # problem with cython 0.27.3
    "-DBUILD_PYTHON_BINDINGS=OFF"
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
  outputs = [ "out" "doc" ];
}
