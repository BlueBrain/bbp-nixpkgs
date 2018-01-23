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
        rev = "084f02f90498c061efb4e7002bc5e625af8e3e68";
        sha256 = "0w445ab8lgk1djnf1a4b13m2kxwhvx60py31dlk3rqzmi01bclaa";
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
