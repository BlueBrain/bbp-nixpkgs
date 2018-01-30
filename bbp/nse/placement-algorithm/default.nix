{
  stdenv,
  config,
  fetchgitPrivate,
  boost,
  pythonPackages,
  brainbuilder,
  voxcell
}:

stdenv.mkDerivation rec {
  name = "placement-algorithm-${version}";
  version = "2018.01-${stdenv.lib.substring 0 6 src.rev}";

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/placementAlgorithm";
    rev = "81daebb141b1876a595d5adf695e9151eca1b9a3";
    sha256 = "16v0mpq1w158791pqwk0q1hnkgnyhlnm8d6migh81irq1479b7g0";
  };

  buildInputs = [
    boost
    stdenv
    pythonPackages.nose
  ];

  propagatedBuildInputs = [
    pythonPackages.numpy
    pythonPackages.pyspark

    brainbuilder
    voxcell
  ];

  doCheck = true;
  checkTarget = "test";

  installFlags = "PREFIX=$(out)";
}
