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
    ignoreCollisions = true;
  };

in

stdenv.mkDerivation rec {
  name = "placement-algorithm-${version}";
  version = "2018.07.12-${stdenv.lib.substring 0 6 src.rev}";

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/placementAlgorithm";
    rev = "9954144db2a76916cedb6ea2fabe99acf831bab2";
    sha256 = "0s156sk6dgym0wpaakigqhxkfnz5nwpzvgiw2y5fr2ix24dc498l";
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
