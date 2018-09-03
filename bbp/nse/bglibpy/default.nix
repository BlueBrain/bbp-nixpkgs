{ config
, fetchgitPrivate
, pythonPackages
, bluepy
, brion
, neuron
}:


pythonPackages.buildPythonPackage rec {
    pname = "bglibpy";
    version = "3.2.51";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/sim/BGLibPy";
        rev = "0d098440734185f4ab6fa36910556446895fe9f9 ";
        sha256 = "1fv4hnnhgls1hwkvz77115j4rm3gqpv38ljyfwgnmb1i219iad0s";
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



