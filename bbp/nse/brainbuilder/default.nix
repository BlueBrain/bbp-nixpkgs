{
  config,
  fetchgitPrivate,
  pythonPackages,
  voxcell
}:

pythonPackages.buildPythonPackage rec {
    pname = "brainbuilder";
    version = "0.7.0";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/brainbuilder";
        rev = "0401c60755942e5882e74e4ec74297ef1770689e";
        sha256 = "1hhak69gmkjkgdmzmril7sqnlmj568gfisx62mn33jg3ib7hykiq";
    };

    buildInputs = with pythonPackages; [
        mock
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
        click
        future
        h5py
        lxml
        numpy
        numpy-stl
        pandas
        pyyaml
        six
        scipy
        tess
        tqdm
    ] ++ [
        voxcell
    ];

    checkPhase = ''
        nosetests tests
    '';
}
