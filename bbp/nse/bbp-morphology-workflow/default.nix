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
    version = "0.1.2";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/platform/bbp-morphology-workflow";
        rev = "68b1f17fa24e1d7304db6a9e10f3bd03a18bcf02";
        sha256 = "02fgbv82hwcgwl9s7xkf999xwn6ngiv5qw710vfv9ph1mjasgb44";
    };

    checkInputs = with pythonPackages; [
        coverage
        mock
        nose
        pycodestyle
        pylint
    ];

    propagatedBuildInputs = with pythonPackages; [
        pathlib
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
        nosetests tests
        nosetests functional_tests
        runHook postCheck
    '';
}
