{
  config,
  fetchgitPrivate,
  pythonPackages,
  bluepy,
  voxcell
}:

pythonPackages.buildPythonPackage rec {
    pname = "brainbuilder";
    version = "0.8.0";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/brainbuilder";
        rev = "92841e61f06e73cfd1b4c4c08abe7e0ee9090231";
        sha256 = "1hl7vhqc72wd517871zjskmwxz6gfqpj8g572krfvnf4ggdpkcwn";
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
        numpy-stl
        pandas
        pyyaml
        six
        scipy
        tess
        tqdm
        transforms3d
    ] ++ [
        bluepy
        voxcell
    ];

    checkPhase = ''
        nosetests tests
    '';
}
