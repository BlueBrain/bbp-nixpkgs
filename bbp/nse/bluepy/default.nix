{ config
, fetchgitPrivate
, pythonPackages
, bluepy-configfile
, brion
, entity-management
, flatindexer
, neurom
, stdenv
, voxcell
, libsonata
}:


pythonPackages.buildPythonPackage rec {
    pname = "bluepy";
    version = "0.13.4";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/bluepy";
        rev = "1700d7f4e0f7b4fee606f2ac97fd12d416f8c76c";
        sha256 = "1nipgzdv188cdylwxnmjdq7x3lprh0hjmyjfndvzzf1fmwndjpiv";
    };

    # TODO: remove once `bluepy` dependencies are revised
    preConfigure = ''
        # remove progressbar requirements
        sed '/progressbar2>=3.18/d' -i setup.py
        sed 's@progressbar.=2.3@progressbar>=2.2@i' -i setup.py
    '';

    buildInputs = with pythonPackages; [
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
        enum34
        h5py
        jsonschema
        lazy
        lxml
        numpy
        pandas
        progressbar
        pyyaml
        pylru
        shapely
        six
        sqlalchemy
    ] ++ [
        bluepy-configfile
        brion
        entity-management
        flatindexer
        neurom
        voxcell
        libsonata
    ];

    # TEMPORARILY disable tests on Python 3
    doCheck = !stdenv.lib.versionAtLeast pythonPackages.python.pythonVersion "3";

    checkPhase = ''
        nosetests tests/v2
    '';
}
