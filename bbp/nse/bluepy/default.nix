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
    version = "0.11.13";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/bluepy";
        rev = "c58f8e157370cf6252658f0bede371852ab76268";
        sha256 = "0s275d2r7nh9sbdmdnqs4fyl9haw83khq36my8cizjy4gg3bzyy3";
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
