{
  bbpsdk-legacy,
  bluejittersdk,
  bluerepairsdk,
  config,
  fetchgitPrivate,
  morphscale,
  muk,
  neurodamus,
  neurom,
  pythonPackages,
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
        coverage
        mock
        nose
        pycodestyle
        pylint
    ];

    propagatedBuildInputs = with pythonPackages; [
        bbpsdk-legacy
        bluejittersdk
        bluerepairsdk
        morphscale
        muk
        neurodamus
        neurom
    ];

    checkPhase = ''
        runHook preCheck
        nosetests morphology_repair_workflow/tests
        runHook postCheck
    '';
}
