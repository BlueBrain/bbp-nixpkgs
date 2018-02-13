{
  config,
  fetchgitPrivate,
  pythonPackages,
  bglibpy,
  bluepy
}:


pythonPackages.buildPythonPackage rec {
    pname = "psp-validation";
    version = "0.1.3";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/psp-validation";
        rev = "f440ada4fe94fda6f2b3f07ae680d8252ffe2b07";
        sha256 = "0cnv83kb9c5dipnh4qxkii4wjfm99ifw3mp4dzpj23i3wzv7zmr2";
    };

    buildInputs = with pythonPackages; [
        nose
    ];

    propagatedBuildInputs = with pythonPackages; [
        click
        h5py
        numpy
        tqdm
    ] ++ [
        bglibpy
        bluepy
    ];

    # TODO: enable tests
    doCheck = false;
}
