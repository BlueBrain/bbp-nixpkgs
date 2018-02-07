{ stdenv
, config
, fetchgitPrivate
, pythonPackages
, voxcell
}:

pythonPackages.buildPythonPackage rec {
    pname = "brainbuilder";
    version = "0.5.7";
    name = "${pname}-${version}";

    src = pythonPackages.fetchBBPDevpi {
        inherit pname version;
        sha256 = "e74e4d28558eb00f322d94799a6203f3733d9a16c36190eceeb19ddf7fc79b88";
    };

    buildInputs = with pythonPackages; [
        mock
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
        click
        future
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
