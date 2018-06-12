{
  config,
  fetchgitPrivate,
  pythonPackages
}:

pythonPackages.buildPythonPackage rec {
    pname = "voxcell";
    version = "2.4.0";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/voxcell";
        rev = "85493a7b562fe7ea949cfc9d3ed5aeda9551050c";
        sha256 = "160lv0gn7m1014m5cml4w3kx84qja192wfi4jhrrad81w8bbiwnx";
    };

    buildInputs = with pythonPackages; [
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
        h5py
        numpy
        pandas
        pynrrd
        requests
        scipy
        six
    ];
}
