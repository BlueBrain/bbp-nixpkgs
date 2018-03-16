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
    version = "0.11.16";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/bluepy";
        rev = "9fe98a83b3ef3607a020b57095794a3817245ae5";
        sha256 = "1yka8gi22d6vwjrqv67pknaxxhd956svcrjpa6a13z3pina32f8b";
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
