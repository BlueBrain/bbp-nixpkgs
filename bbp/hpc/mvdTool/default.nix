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
  version = "1.5";
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
    rev = "1fd68194406465d631ce2ad3af9538410fe23a0c";
    sha256 = "1a806x8730p11m1ddnr5nzij1k7sk4dls1scndk4i47d88v5wysa";
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
  postInstall = [
	"mkdir -p $doc/share"
    ] ++ ((stdenv.lib.optional) (pandoc != null) [''
    mkdir -p $out/share/doc/morpho-mesher/html
    ${pandoc}/bin/pandoc -s -S --self-contained \
      -c ${docCss} ${src}/README.md \
      -o $out/share/doc/morpho-mesher/html/index.html
  '' ]);

  passthru = {
    pythonModule = pythonPackages.python;
  };
  outputs = [ "out" "doc" ];

}
