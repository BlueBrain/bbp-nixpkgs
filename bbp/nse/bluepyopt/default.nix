{
  config,
  fetchFromGitHub,
  pythonPackages
}:

pythonPackages.buildPythonPackage rec {
    pname = "BluePyOpt";
    version = "1.6.27";
    name = "${pname}-${version}";

    src = fetchFromGitHub {
	owner = "BlueBrain";
	repo = "BluePyOpt";
        rev = "e4b159bf325eaa7af914541e78a89c78632f1026";
        sha256 = "0b0bdwwfniwrrm3pd1nljp212kx9dn40kdjwn8n1zx8vwn41hmpw";
    };

    preConfigure = ''
		sed -i 's@0.7.3@0.5@g' setup.py;
    '';

    propagatedBuildInputs = with pythonPackages; [
		pandas
		matplotlib
		numpy
		pickleshare
		efel
		jinja2
		future
		ipyparallel
		scoop
		deap
    ];
}
