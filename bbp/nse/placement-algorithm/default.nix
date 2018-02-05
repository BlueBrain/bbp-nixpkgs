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
  version = "2018.02-${stdenv.lib.substring 0 6 src.rev}";

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/placementAlgorithm";
    rev = "c03b53215adb0899eb71113bf51666eb1c1f0161";
    sha256 = "0lj0p4kj48kcnd0vwnrqyzxwb70ghj9315dpvxz4j97gzs3ij468";
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
