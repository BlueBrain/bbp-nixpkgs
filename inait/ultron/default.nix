{ stdenv
, config
, fetchgitPrivate
, pythonPackages
}:


pythonPackages.buildPythonPackage rec {
	name = "ultron-${version}";
	version = "${builtins.substring 0 6 src.rev}";

	src = fetchgitPrivate {
		url = config.inait_git_ssh + "/PIPELINE/ultron.git";
		rev = "babe5a9afb701e5a9d56641bbb3e64eea26645e2";
		sha256 = "0jykk6i2ac3n6qwg4arn1kg3hi2g6r7y67bymdygz6hpnj3z3lq0";
	};

	propagatedBuildInputs = [ pythonPackages.numpy pythonPackages.h5py pythonPackages.pyjarvis ];
}
