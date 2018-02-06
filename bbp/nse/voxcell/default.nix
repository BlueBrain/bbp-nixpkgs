{ stdenv
, config
, fetchgitPrivate
, pythonPackages
}:

pythonPackages.buildPythonPackage rec {
    pname = "voxcell";
    version = "2.3.3";
    name = "${pname}-${version}";

    src = pythonPackages.fetchBBPDevpi {
      inherit pname version;
      sha256 = "018bc23dcceb102b91c4f40ec35ef22de0e6dd3f41818bfd7ac5870eb8eecb24";
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
