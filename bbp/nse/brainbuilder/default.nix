{
  config,
  fetchgitPrivate,
  pythonPackages,
  voxcell
}:

pythonPackages.buildPythonPackage rec {
    pname = "brainbuilder";
    version = "0.5.7";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/brainbuilder";
        rev = "d2fb5b11b08f1d69677ed87efa932475b3f6cbc2";
        sha256 = "0p0jpsk5iyry2jg0j101gvyjdh6ssyxdx51b3rglbm7inf6whl63";
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
}
