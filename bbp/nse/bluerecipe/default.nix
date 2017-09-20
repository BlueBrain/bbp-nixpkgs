{ config, fetchgitPrivate, pythonPackages, bluepy_0_11_2, equation }:

pythonPackages.buildPythonPackage rec {
  name = "bluerecipe-${version}";
  version = "0.1.2.dev0";
  
  src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/nse/bluerecipe";
    rev = "889a7f75f838c69dd689a3f3f66fa5b22d25fe4b";
    sha256 = "0brr22f77y2z6j32g4z78qvd3b7j0f9fnp4prcyrz4n63p5rp6yb";
  };

  propagatedBuildInputs = with pythonPackages; [ lxml equation bluepy_0_11_2 ];

  configurePhase = null;

  preBuild = "cd bluerecipe";
  postBuild = "cd ..";
  preCheck = preBuild;
  postCheck = postBuild;
  preInstall = preBuild;
  postInstall = postBuild;

  meta = {
    description = "Build cell collection";
    homepage = http://bluebrain.epfl.ch;
    maintainers = [ "NSE Team" ];
  };
}
