{ config
, fetchgitPrivate
, pythonPackages
, bluepy
, brion
, neuron
}:


pythonPackages.buildPythonPackage rec {
    pname = "bglibpy";
    version = "3.2.47";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/BGLibPy";
        rev = "97526161995fbc73f8517b3e9445d10f7f8a6a6b";
        sha256 = "0nppymkpq337ipfiy5dlhs1bsr1ahy0c4rj14qjwrwqjlqrnvwar";
    };

    patches = [
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



