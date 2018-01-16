{ stdenv
, config
, fetchgitPrivate
, pythonPackages
}:


pythonPackages.buildPythonPackage rec {
	name = "pybinreports-${version}";
	
	version = "2018.01-${src.rev}";

	src = fetchgitPrivate {
            url = config.bbp_git_ssh + "/nse/pybinreports";
            rev = "3a09ab66175a0be37cf544ef6bb71abbebcfe86f";
            sha256 = "0mig991i5lf9j7bvwq34hyk1c4c5yw0lld5l3364fz2n6kzmbqs9";
        };

	preConfigure = ''
		cd pybinreports;
	'';

	propagatedBuildInputs = [
	    pythonPackages.numpy
	];

}



