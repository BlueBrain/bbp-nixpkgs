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
	name = "bglibpy-${version}";
	
	version = "2018.01-${stdenv.lib.substring 0 6 src.rev}";

	src = fetchgitPrivate {
            url = config.bbp_git_ssh + "/sim/BGLibPy";
            rev = "4658871de80563463dc946fed57013e0a72eb137";
            sha256 = "0w445ab8lgk1djnf1a4b13m2kxwhvx60py31dlk3rqzmi01bcl7m";
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



