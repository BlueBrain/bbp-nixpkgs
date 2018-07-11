{
  config,
  fetchgitPrivate,
  pythonPackages
}:

pythonPackages.buildPythonPackage rec {
    pname = "voxcell";
    version = "2.5.0";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/voxcell";
        rev = "22bad5f5694de0ad3c1e892e6c08955a87a72e5d";
        sha256 = "0vzzqkngzr1lygagi5m9a5xp78jjvhs433289xq3nryzqvhfpcdk";
    };

    buildInputs = with pythonPackages; [
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
        future
        h5py
        numba
        numpy
        numpy-quaternion
        pandas
        pynrrd
        requests
        scipy
        six
    ];
}
