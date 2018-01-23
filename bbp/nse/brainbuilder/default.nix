{ stdenv
, config
, fetchgitPrivate
, pythonPackages
, voxcell
}:

pythonPackages.buildPythonPackage rec {
    name = "brainbuilder-${version}";
    version = "0.5.6";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/brainbuilder";
        rev = "47393793ed8cb6aad097df6044f7be20083b6b60";
        sha256 = "04a9ak6zf1jjlf04xcxvf3vqa78aag2w7gfs63hlik29ymbv88p9";
    };

    buildInputs = with pythonPackages; [
        mock
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
        click
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
