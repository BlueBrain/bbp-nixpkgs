{
  stdenv,
  config,
  fetchgitPrivate,
  boost,
  python,
  pythonPackages,
  brainbuilder,
  voxcell
}:


let
  python-env = python.buildEnv.override {
    extraLibs = [
      pythonPackages.numpy
      pythonPackages.requests
      brainbuilder
      voxcell
    ];
  };

in

stdenv.mkDerivation rec {
  name = "placement-algorithm-${version}";
  version = "2018.08.31-${stdenv.lib.substring 0 6 src.rev}";

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/placementAlgorithm";
    rev = "bf2f27c7fd03e267d59536830950a33ea6c0076e";
    sha256 = "15rh3sxi0ja409wvvd5lijmp2ab8s0j088n9iyrcyipndl7msxk2";
  };

  buildInputs = [
    boost
    stdenv
    python-env
    pythonPackages.nose
  ];

  doCheck = true;
  checkTarget = "test";

  installFlags = "PREFIX=$(out)";

  postInstall = ''
    LAUNCHER="$out/bin/assign-morphologies"
    cat << EOF > "$LAUNCHER"
    export PYSPARK_PYTHON=${python-env.interpreter}
    export PYSPARK_DRIVER_PYTHON=${python-env.interpreter}
    spark-submit "$out/share/pyspark/assign_morphologies.py" \$@
    EOF
    chmod +x "$LAUNCHER"
  '';
}
