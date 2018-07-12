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
  version = "2018.07.12-${stdenv.lib.substring 0 6 src.rev}";

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/placementAlgorithm";
    rev = "aaa4309256a50dfcc475f0b9fcde74ba410d4aad";
    sha256 = "0dsgmqa0kyq9m5v58lmv7zrw2d5hw576xlix058b2bi2jw76vdh0";
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
