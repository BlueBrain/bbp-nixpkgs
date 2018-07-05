{
  config,
  fetchgitPrivate,
  pythonPackages,
  voxcell
}:

pythonPackages.buildPythonPackage rec {
    pname = "brainbuilder";
    version = "0.6.2";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/brainbuilder";
        rev = "cec8a2343d0be8ac70e9c4dc0da622fe02cd007d";
        sha256 = "1ws8wmz9xq5mbl2639jicj32hr1n6jysdsmppgb5b1dqv9s2k22c";
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
