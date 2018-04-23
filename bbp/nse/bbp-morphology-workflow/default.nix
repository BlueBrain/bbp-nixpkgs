{
  config,
  fetchgitPrivate,
  pythonPackages,
  neurom,
  neurodamus,
  bbpsdk-legacy,
  muk,
  bluerepairsdk,
  morphscale,
  bluejittersdk,
}:

pythonPackages.buildPythonPackage rec {
    pname = "bbp-morphology-workflow";
    version = "0.0.3.dev1";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/platform/bbp-morphology-workflow";
        rev = "4808570b7914dc621db45a2709f62cfcea73d57c";
        sha256 = "0adll1vz0nb1y9rrmv8w8r8h66pb9nb4id1vidpxs0aa9j19cba5";
    };

    checkInputs = with pythonPackages; [
        pylint
        coverage
        pycodestyle
        mock
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
        neurom
        neurodamus
        bbpsdk-legacy
        muk
        bluerepairsdk
        morphscale
        bluejittersdk
    ];

    checkPhase = ''
        nosetests morphology_repair_workflow/tests
    '';
}
