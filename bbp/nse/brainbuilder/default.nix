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
        rev = "84f412845da7947643acd5a211a519b8980c7f06";
        sha256 = "0w445ab8lgk1djnf1a4b13m2kxwhvx60py31dlk3rqzmi01bclaa";
    };

    buildInputs = with pythonPackages; [
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
