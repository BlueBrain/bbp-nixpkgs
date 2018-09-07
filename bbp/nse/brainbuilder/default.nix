{
  config,
  fetchgitPrivate,
  pythonPackages,
  bluepy,
  voxcell
}:

pythonPackages.buildPythonPackage rec {
    pname = "brainbuilder";
    version = "0.7.3";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/brainbuilder";
        rev = "324cb378fb460cf1a181487d7579c7974237ab20";
        sha256 = "1ivqq84080qjvhf13syc7qhs9zsl5acqlzcxvk4mw6nvmvdlfisr";
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
