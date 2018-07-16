{
  config,
  fetchgitPrivate,
  pythonPackages,
  bluepy-configfile,
  brion,
  entity-management,
  flatindexer,
  neurom,
  voxcell
}:


pythonPackages.buildPythonPackage rec {
    pname = "bluepy";
    version = "0.12.5";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/bluepy";
        rev = "834babaf6778f9b7474e5b824dd98e0d8be90c16";
        sha256 = "0kvkyhzlp29i3sr999h9i7jns4xxjfd9cz0121kib6mihvd2p3xv";
    };

    # TODO: remove once `bluepy` dependencies are revised
    preConfigure = ''
        # use >= deps and not absolute == to avoid conflicts....
        sed -i 's/==\([^ ]\)/>=\1/g' setup.py

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

    checkPhase = ''
        nosetests tests/v2
    '';
}
