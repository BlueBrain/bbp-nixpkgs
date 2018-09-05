{
  config,
  fetchgitPrivate,
  pythonPackages,
  bluepy,
  voxcell
}:

pythonPackages.buildPythonPackage rec {
    pname = "brainbuilder";
    version = "0.7.2";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/brainbuilder";
        rev = "462df6c455951ba4f0bb296649d59812b2320f6a";
        sha256 = "1jz82bzwk29gd5j9d24faaab67qknr698s9l585lyz5lgh9b2k6k";
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
    ] ++ [
        bluepy
        voxcell
    ];

    checkPhase = ''
        nosetests tests
    '';
}
