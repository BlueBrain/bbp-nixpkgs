{
  config,
  fetchgitPrivate,
  pythonPackages
}:

pythonPackages.buildPythonPackage rec {
    pname = "voxcell";
    version = "2.3.4";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/voxcell";
        rev = "54cdefe0ce1ca4b2cf140cee94527c16655a73eb";
        sha256 = "0im7wg6w51rv0zfv0d1j1habqly1w8kp1y64rxmplh6slhpalpcd";
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
