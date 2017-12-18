{
  stdenv,
  config,
  fetchgitPrivate,
  boost,
  pythonPackages
}:

stdenv.mkDerivation rec {
  name = "placement-algorithm-${version}";
  version = "0.0.0";

  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/building/placementAlgorithm";
    rev = "8680f83a91d629192c80383b9bbb982289029d00";
    sha256 = "0afpcxwm05ankbhvaxwx34lnjd7nk3ni43b0ljrlqn031p73bnqg";
  };

  buildInputs = [
    boost
    stdenv
    pythonPackages.nose
    pythonPackages.numpy
  ];

  configurePhase = ''
    makeFlagsArray=(
      LDFLAGS="-lboost_program_options -lboost_filesystem -L${boost}/lib"
    )
  '';

  doCheck = true;
  checkTarget = "test";
  checkPhase = ''
    runHook preCheck
    make SHELL=$SHELL ${checkTarget} || true
    runHook postCheck
  '';

  installFlags = "PREFIX=$(out)";
}
