{
  config,
  fetchgitPrivate,
  pythonPackages,
  bglibpy,
  bluepy
}:


pythonPackages.buildPythonPackage rec {
    pname = "psp-validation";
    version = "0.1.7";
    name = "${pname}-${version}";

    src = fetchgitPrivate {
        url = config.bbp_git_ssh + "/nse/psp-validation";
        rev = "da5842f4f0109df9eba5d39e25bd285959bc2830";
        sha256 = "00xy1rdgg2hz36lc83mr13l84zsn5ijkawf1kbw1hrnakb2gnh49";
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
