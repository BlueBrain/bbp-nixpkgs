{
  config,
  fetchgitPrivate,
  pythonPackages,
  bluepy-configfile,
  brion,
  entity-management,
  flatindexer,
  neurom,
  stdenv,
  voxcell
}:


pythonPackages.buildPythonPackage rec {
    pname = "bluepy";
    version = "0.12.6";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/bluepy";
        rev = "afc3101a18ee46c269da8a03dd257946af54d117";
        sha256 = "0j3r7xcwkpn9mmm3fpxar4s3nd83h1qbv66d2aayf90sy4lf1hri";
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
    ];

    # TEMPORARILY disable tests on Python 3
    doCheck = !stdenv.lib.versionAtLeast pythonPackages.python.pythonVersion "3";

    checkPhase = ''
        nosetests tests/v2
    '';
}
