{ config
, fetchgitPrivate
, pythonPackages
, bluepy
, brion
, neuron
}:


pythonPackages.buildPythonPackage rec {
    pname = "bglibpy";
    version = "3.2.33";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/BGLibPy";
        rev = "4658871de80563463dc946fed57013e0a72eb137";
        sha256 = "0w445ab8lgk1djnf1a4b13m2kxwhvx60py31dlk3rqzmi01bcl7m";
    };

    patches = [
      ./patch_setup.patch
      ./patch_version.patch
    ];

    propagatedBuildInputs = [
        pythonPackages.numpy
        bluepy
        brion
        neuron
    ];

    doCheck =false;
}



