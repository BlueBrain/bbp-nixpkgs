{ stdenv
, config
, fetchgitPrivate
, pythonPackages
}:

pythonPackages.buildPythonPackage rec {
    name = "voxcell-${version}";
    version = "2.3.3";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/voxcell";
        rev = "b7dff2f38a1101373dbfb9f830004ef9e6e635c7";
        sha256 = "0zr16pivj0yri9hkjlchaj3b5yka5cfn5sfn94m84hk3kcsv3svx";
    };

    buildInputs = with pythonPackages; [
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
        h5py
        numpy
        pandas
        pynrrd
        scipy
        six
    ];
}
