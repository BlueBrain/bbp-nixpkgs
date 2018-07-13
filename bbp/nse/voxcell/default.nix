{
  config,
  fetchgitPrivate,
  pythonPackages
}:

pythonPackages.buildPythonPackage rec {
    pname = "voxcell";
    version = "2.5.1";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/voxcell";
        rev = "7482bbe7469308e3cb4296ed1b9edfed1731ba9c";
        sha256 = "1js3bsml7rdjyx5y37jn0nrddk6547pq4piqrvaacyrhb7c7m1lr";
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
