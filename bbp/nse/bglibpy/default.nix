{ config
, fetchgitPrivate
, pythonPackages
, bluepy
, brion
, neuron
}:


pythonPackages.buildPythonPackage rec {
    pname = "bglibpy";
    version = "3.2.34";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/BGLibPy";
        rev = "4e2f23ece3a2884e04b0fafde378cf2d0341d4c6";
        sha256 = "1ijgr5q75yrlh5nayi3xzq9czs6xin42qh4b6w7wfnfpplhm1s3d";
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



