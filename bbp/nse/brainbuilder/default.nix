{ config, fetchgitPrivate, buildPythonPackage, pythonPackages, pynrrd, voxcell, numpy_1_13_1 }:

let
  brainbuilder_src = fetchgitPrivate {
    url = config.bbp_git_ssh + "/platform/BrainBuilder";
    rev =  "f2f608e6f436c41006ac0194243bbda1c460d96d";
    sha256 = "0izljzdjf0gm65jn2db0a1rs6rg00dvqmrv68723l7b8agzrhbwd";
  };
in {
  voxcell = buildPythonPackage rec {
    name = "voxcell-${version}";
    version = "2.1.1.dev0";
    
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
    version = "0.4.2.dev0";
    
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
