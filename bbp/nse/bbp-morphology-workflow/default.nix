{
  bbpsdk-legacy,
  bluejittersdk,
  bluerepairsdk,
  config,
  fetchgitPrivate,
  morphscale,
  morph-tool,
  muk,
  neurodamus,
  neurom,
  pythonPackages,
}:

pythonPackages.buildPythonPackage rec {
    pname = "bbp-morphology-workflow";
    version = "0.0.4";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/platform/bbp-morphology-workflow";
        rev = "43548cbcb87da71c8185f0ef7b948f4f84c475e8";
        sha256 = "0f5p7y2g8gqqvgnf83h0lvrlh1a2hpj0v99kirc8fxgf2x4vpsvd";
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
        morph-tool
        muk
        neurodamus
        neurom
        six
    ];

    checkPhase = ''
        runHook preCheck
        nosetests morphology_repair_workflow/tests
        runHook postCheck
    '';
}
