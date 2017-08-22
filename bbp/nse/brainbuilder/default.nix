{ config, fetchgitPrivate, buildPythonPackage, pythonPackages, pynrrd, voxcell, numpy_1_13_1 }:

let
  brainbuilder_src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/platform/BrainBuilder";
    rev =  "7247afe1f30aa96032929f3bf4b8bf5d578f89da";
    sha256 = "08kimzcpkcbkap7419mkbwnbss5d6xqkmgfp4xyml1vmx2bbvdjz";
  };
in {
  voxcell = buildPythonPackage rec {
    name = "voxcell-${version}";
    version = "2.1.0.dev1";
    
    src = brainbuilder_src;

    propagatedBuildInputs = with pythonPackages; [ numpy_1_13_1 pandas h5py six pynrrd ];

    configurePhase = null;

    preBuild = "cd voxcell";
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
  };

  brain-builder = buildPythonPackage rec {
    name = "brain-builder-${version}";
    version = "0.4.1.dev1";
    
    src = brainbuilder_src;

    propagatedBuildInputs = with pythonPackages; [ numpy_1_13_1 pandas h5py scipy lxml six voxcell ];

    configurePhase = null;

    preBuild = "cd brainbuilder";
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
  };
}
