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
    version = "0.0.3";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/platform/bbp-morphology-workflow";
        rev = "41fa55dd9d6ea899844068336d4abf46952f04fc";
        sha256 = "04gvw5gb8cxsbr95025z00lxi5839sclvzmdmmzic7vyclnrh7z4";
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
