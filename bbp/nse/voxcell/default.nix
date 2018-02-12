{
  config,
  fetchgitPrivate,
  pythonPackages
}:

pythonPackages.buildPythonPackage rec {
    pname = "voxcell";
    version = "2.3.3";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/voxcell";
        rev = "084f02f90498c061efb4e7002bc5e625af8e3e68";
        sha256 = "1d3cln56764nxq7rlzng0vcfrkjg25aishqq1s80fpbg2idajid4";
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
