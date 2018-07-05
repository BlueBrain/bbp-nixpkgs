{
  config,
  fetchgitPrivate,
  pythonPackages
}:

pythonPackages.buildPythonPackage rec {
    pname = "voxcell";
    version = "2.4.1";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/voxcell";
        rev = "0f4b5839dd60235f0d3a70abf1629bdb8e650b6d";
        sha256 = "1kcrjnh8xxxa9r8iv8mkryi2bllpr1dpcdld0mavm1p04449cl2x";
    };

    buildInputs = with pythonPackages; [
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
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
