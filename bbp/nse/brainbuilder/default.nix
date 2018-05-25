{
  config,
  fetchgitPrivate,
  pythonPackages,
  voxcell
}:

pythonPackages.buildPythonPackage rec {
    pname = "brainbuilder";
    version = "0.6.0";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/brainbuilder";
        rev = "a403f8d2a16c8c553e19ed24e6f77ac8fa0ed50b";
        sha256 = "0jrzrsfv08pni4fga6076a79n4ydmwwwz96nrawa9bv41ss03y1v";
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
