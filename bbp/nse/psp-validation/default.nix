{
  config,
  fetchgitPrivate,
  pythonPackages,
  bglibpy,
  bluepy
}:


pythonPackages.buildPythonPackage rec {
    pname = "psp-validation";
    version = "0.1.10";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/psp-validation";
        rev = "b132e4138411a0a4a9a87960cb9c7ae2c83e70e7";
        sha256 = "1c76z09h617fwf1y88i3gxpmjas9qrzdy9g2s8gqxqjl4r3x15cq";
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
