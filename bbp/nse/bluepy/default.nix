{
  config,
  fetchgitPrivate,
  pythonPackages,
  bluepy-configfile,
  brion,
  flatindexer,
  neurom
}:


pythonPackages.buildPythonPackage rec {
    pname = "bluepy";
    version = "0.12.0";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/bluepy";
        rev = "7f399cf0aff2a40133acb5111e490600c8897e30";
        sha256 = "0zvzn1fhchjaq04v9r8yiajbfz5w2gf57qxi43s6sc4f2axgf58r";
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
        flatindexer
        neurom
    ];

    checkPhase = ''
        nosetests tests/v2
    '';
}
