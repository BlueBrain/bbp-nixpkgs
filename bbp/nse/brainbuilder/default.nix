{
  config,
  fetchgitPrivate,
  pythonPackages,
  voxcell
}:

pythonPackages.buildPythonPackage rec {
    pname = "brainbuilder";
    version = "0.5.12";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/brainbuilder";
        rev = "8462eb576bf6b2b7c83353c694c877168dad35a7";
        sha256 = "0wm42x74c77yqcw1a2v2s43lqffnwly9jy7qa6fgczg231psz1m6";
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
        pandas
        pyyaml
        requests
        six
        scipy
        tqdm

        voxcell
    ];

    checkPhase = ''
        nosetests tests
    '';
}
