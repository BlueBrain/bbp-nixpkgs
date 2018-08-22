{
  config,
  fetchgitPrivate,
  pythonPackages,
  voxcell
}:

pythonPackages.buildPythonPackage rec {
    pname = "brainbuilder";
    version = "0.7.1";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/brainbuilder";
        rev = "8fa80becaeddbafb703870adedf33eb9a90aada7";
        sha256 = "09zw4y9r6xi5rjcijs7kw22hgivs39f87cychmh2narcxyinw74i";
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
