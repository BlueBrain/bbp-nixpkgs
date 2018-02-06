{ stdenv
, config
, fetchgitPrivate
, pythonPackages
, bluepy
, brion
, pybinreports
, neuron
}:


pythonPackages.buildPythonPackage rec {
    pname = "bglibpy";
    version = "3.2.33";
    name = "${pname}-${version}";

    src = pythonPackages.fetchBBPDevpi {
        inherit pname version;
        sha256 = "9c6b8a876df080bf73ba73999d85a89349c487c47423c4e89847cd648c758167";
    };

    patches = [ ./patch_brain.patch ];

    propagatedBuildInputs = [
        pythonPackages.numpy
        bluepy
        brion
        pybinreports
        neuron
    ];

    doCheck =false;
}



