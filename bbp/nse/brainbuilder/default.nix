{
  config,
  fetchgitPrivate,
  pythonPackages,
  bluepy,
  voxcell
}:

pythonPackages.buildPythonPackage rec {
    pname = "brainbuilder";
    version = "0.8.1";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/brainbuilder";
        rev = "394ae764d68f32c89bb28143b3dc014d9197a826";
        sha256 = "1gijn1cfvvyl775gk1wic9q7nwc024jmfqb6myqz3k03xx54bm96";
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
